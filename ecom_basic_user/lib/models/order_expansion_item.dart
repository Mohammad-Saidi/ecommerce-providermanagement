import 'address_model.dart';
import 'cart_model.dart';
import 'date_model.dart';
import 'user_model.dart';

class OrderExpansionItem {
  OrderExpansionHeader header;
  OrderExpansionBody body;
  bool isExpanded;
  OrderExpansionItem({
    required this.header,
    required this.body,
    this.isExpanded = false,
  });
}

class OrderExpansionHeader {
  String orderId;
  String orderStatus;
  DateModel orderDate;
  num grandTotal;

  OrderExpansionHeader({
    required this.orderId,
    required this.orderStatus,
    required this.orderDate,
    required this.grandTotal,
  });
}

class OrderExpansionBody {
  UserModel userModel;
  String paymentMethod;
  num discount;
  num VAT;
  num deliveryCharge;
  AddressModel deliveryAddress;
  List<CartModel> productDetails;

  OrderExpansionBody({
    required this.userModel,
    required this.paymentMethod,
    required this.discount,
    required this.VAT,
    required this.deliveryCharge,
    required this.deliveryAddress,
    required this.productDetails,
  });
}
