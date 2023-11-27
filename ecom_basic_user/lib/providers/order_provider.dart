import 'package:ecom_basic_user/auth/auth_service.dart';
import 'package:ecom_basic_user/models/order_model.dart';
import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/order_constant_model.dart';
import '../models/order_expansion_item.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();
  List<OrderModel> myOrders = [];

  getMyOrders() {
    DbHelper.getAllOrdersByUser(AuthService.currentUser!.uid).listen((event) {
      myOrders = List.generate(event.docs.length,
          (index) => OrderModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getOrderConstants() {
    DbHelper.getOrderConstants().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  int getDiscountAmount(num subTotal) {
    return (subTotal * orderConstantModel.discount) ~/ 100;
  }

  int getVatAmount(num subTotal) {
    final priceAfterDiscount = subTotal - getDiscountAmount(subTotal);
    return (priceAfterDiscount * orderConstantModel.vat) ~/ 100;
  }

  int getGrandTotal(num subTotal) {
    return (subTotal -
            getDiscountAmount(subTotal) +
            getVatAmount(subTotal) +
            orderConstantModel.deliveryCharge)
        .round();
  }

  Future<void> saveOrder(OrderModel order) {
    return DbHelper.saveOrder(order);
  }

  List<OrderExpansionItem> getExpansionItems() {
    return List.generate(myOrders.length, (index) {
      final order = myOrders[index];
      return OrderExpansionItem(
        header: OrderExpansionHeader(
          orderId: order.orderId,
          orderStatus: order.orderStatus,
          grandTotal: order.grandTotal,
          orderDate: order.orderDate,
        ),
        body: OrderExpansionBody(
          userModel: order.userModel,
          paymentMethod: order.paymentMethod,
          discount: order.discount,
          VAT: order.VAT,
          deliveryCharge: order.deliveryCharge,
          deliveryAddress: order.deliveryAddress,
          productDetails: order.productDetails,
        ),
      );
    });
  }
}
