import 'package:ecom_basic_user/auth/auth_service.dart';
import 'package:ecom_basic_user/db/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  num priceWithQuantity(CartModel cartModel) =>
      num.parse(cartModel.productModel.calculatePriceAfterDiscount()) * cartModel.quantity;

  int get totalItemsInCart => cartList.length;

  bool isProductInCart(String pid) {
    bool tag = false;
    for (final cartModel in cartList) {
      if (cartModel.productModel.productId == pid) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  Future<void> addToCart(ProductModel productModel) {
    final cartModel = CartModel(productModel: productModel);
    return DbHelper.addToCart(cartModel, AuthService.currentUser!.uid);
  }

  Future<void> removeFromCart(String pid) {
    return DbHelper.removeFromCart(pid, AuthService.currentUser!.uid);
  }

  void getAllCartItems() {
    DbHelper.getCartItems(AuthService.currentUser!.uid).listen((snapshot) {
      cartList = List.generate(snapshot.docs.length, (index) =>
      CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  void increaseQuantity(CartModel cartModel) {
    cartModel.quantity += 1;
    DbHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
  }

  void decreaseQuantity(CartModel cartModel) {
    if(cartModel.quantity > 1) {
      cartModel.quantity -= 1;
      DbHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
    }
  }

  num getCartSubTotal() {
    num total = 0;
    for (final cartModel in cartList) {
      total += priceWithQuantity(cartModel);
    }
    return total;
  }

  Future<void> clearCart() {
    return DbHelper.clearCart(AuthService.currentUser!.uid, cartList);
  }
}
