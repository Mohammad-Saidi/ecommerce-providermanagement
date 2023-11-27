import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_basic_user/models/cart_model.dart';
import 'package:ecom_basic_user/models/order_model.dart';
import 'package:ecom_basic_user/models/rating_model.dart';
import 'package:ecom_basic_user/models/user_model.dart';

import '../models/category_model.dart';
import '../models/order_constant_model.dart';
import '../models/product_model.dart';

class DbHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addToCart(CartModel cartModel, String uid) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> removeFromCart(String pid, String uid) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid)
        .delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrdersByUser(String uid) =>
      _db.collection(collectionOrder)
          .where('$orderFieldUser.$userFieldId', isEqualTo: uid)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartItems(String uid) =>
      _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db
          .collection(collectionOrderConstant)
          .doc(documentOrderConstant)
          .snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(String uid) {
    return _db.collection(collectionUser).doc(uid).snapshots();
  }

  static Future<void> updateProductField(String pid, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(pid).update(map);
  }

  static Future<void> addUser(UserModel userModel) {
    return _db
        .collection(collectionUser)
        .doc(userModel.userId)
        .set(userModel.toMap());
  }

  static Future<void> updateCartQuantity(String uid, CartModel cartModel) {
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> saveOrder(OrderModel order) async {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc(order.orderId);
    wb.set(orderDoc, order.toMap());
    for(final cartModel in order.productDetails) {
      final productSnapshot = await _db.collection(collectionProduct)
          .doc(cartModel.productModel.productId)
          .get();
      final categorySnapshot = await _db.collection(collectionCategory)
          .doc(cartModel.productModel.category.categoryId)
          .get();
      final prevProductStock = productSnapshot.data()![productFieldStock];
      final prevCatProCount = categorySnapshot.data()![categoryFieldProductCount];
      final proDoc = _db.collection(collectionProduct).doc(cartModel.productModel.productId);
      final catDoc = _db.collection(collectionCategory).doc(cartModel.productModel.category.categoryId);
      wb.update(proDoc, {productFieldStock : prevProductStock - cartModel.quantity});
      wb.update(catDoc, {categoryFieldProductCount : prevCatProCount - cartModel.quantity});
    }
    final userDoc = _db.collection(collectionUser).doc(order.userModel.userId);
    wb.set(userDoc, order.userModel.toMap());
    return wb.commit();
  }

  static Future<void> clearCart(String uid, List<CartModel> cartList) {
    final wb = _db.batch();
    for(final cartModel in cartList) {
      final doc = _db.collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .doc(cartModel.productModel.productId);
      wb.delete(doc);
    }
    return wb.commit();
  }

  static Future<void> addRating(RatingModel ratingModel) {
    return _db.collection(collectionProduct)
        .doc(ratingModel.productId)
        .collection(collectionRating)
        .doc(ratingModel.ratingId)
        .set(ratingModel.toMap());

  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getRatingsByProduct(String pid) {
    return _db.collection(collectionProduct)
        .doc(pid)
        .collection(collectionRating)
        .get();
  }
}
