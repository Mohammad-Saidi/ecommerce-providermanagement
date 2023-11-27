import 'dart:io';

import 'package:ecom_basic_user/models/rating_model.dart';
import 'package:ecom_basic_user/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/image_model.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) { 
      categoryList = List.generate(snapshot.docs.length, (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> updateProductField(String pid, String field, dynamic value) {
    return DbHelper.updateProductField(pid, {field : value});
  }

  Future<ImageModel> uploadImage(String imageLocalPath) async {
    final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}';
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('$imageDirectory$imageName');
    final uploadTask = photoRef.putFile(File(imageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return ImageModel(
      imageName: imageName,
      downloadUrl: url,
      directoryName: imageDirectory,
    );
  }

  Future<void> deleteImage(ImageModel image) async {
    final photoRef = FirebaseStorage.instance.ref()
        .child('${image.directoryName}${image.imageName}');
    return photoRef.delete();
  }

  Future<void> addRating(String pid, UserModel userModel, double userRating) async {
    final ratingModel = RatingModel(
      ratingId: userModel.userId,
      userModel: userModel,
      productId: pid,
      rating: userRating
    );
    await DbHelper.addRating(ratingModel);
    final snapshot = await DbHelper.getRatingsByProduct(pid);
    final ratingList = List.generate(snapshot.docs.length, (index) =>
      RatingModel.fromMap(snapshot.docs[index].data()));
    double temp = 0.0;
    for(final rating in ratingList) {
      temp += rating.rating;
    }
    final avgRating = temp / ratingList.length;
    return DbHelper.updateProductField(pid, {productFieldAvgRating : avgRating});
  }
}