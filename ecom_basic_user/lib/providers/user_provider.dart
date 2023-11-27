import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_basic_user/auth/auth_service.dart';
import 'package:ecom_basic_user/db/db_helper.dart';
import 'package:ecom_basic_user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  Future<void> addUser(User user) {
    final userModel = UserModel(
      userId: user.uid,
      email: user.email!,
      displayName: user.displayName,
      phone: user!.photoURL,
      userCreationTime: Timestamp.fromDate(DateTime.now()),
    );
    return DbHelper.addUser(userModel);
  }

  getUserInfo() {
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if(snapshot.exists) {
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<bool> doesUserExist(String uid) => DbHelper.doesUserExist(uid);
}