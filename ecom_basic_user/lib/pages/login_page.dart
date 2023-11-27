import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_basic_user/auth/auth_service.dart';
import 'package:ecom_basic_user/pages/launcher_page.dart';
import 'package:ecom_basic_user/pages/view_product_page.dart';
import 'package:ecom_basic_user/providers/user_provider.dart';
import 'package:ecom_basic_user/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errMsg = '';

  @override
  void initState() {
    _emailController.text = 'user1@gmail.com';
    _passwordController.text = '123456';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Welcome, User',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Provide a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password(at least 6 characters)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Provide a valid password';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _authenticate(true);
                },
                child: Text(
                  'SIGN IN',
                ),
                style:
                    ElevatedButton.styleFrom(foregroundColor: kShrineBrown900),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User?'),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      _authenticate(false);
                    },
                    child: const Text('SIGN UP'),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: kShrineBrown900),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Forgot password',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        foregroundColor: kShrineBrown900),
                    child: const Text('Click Here'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errMsg,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    foregroundColor: kShrineBrown900),
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('SIGNIN WITH GOOGLE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate(bool isLogin) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        User user;
        if (isLogin) {
          user = await AuthService.loginUser(email, password);
        } else {
          user = await AuthService.registerUser(email, password);
          await Provider.of<UserProvider>(context, listen: false).addUser(user);
        }

        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, ViewProductPage.routeName);
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }

  void _signInWithGoogle() async {
    final credential = await AuthService.signInWithGoogle();
    final exists = await Provider.of<UserProvider>(context, listen: false)
    .doesUserExist(credential.user!.uid);
    if(!exists) {
      EasyLoading.show(status: 'Redirecting');
      await Provider.of<UserProvider>(context, listen: false).addUser(credential.user!);
    }
    if(EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    Navigator.pushReplacementNamed(context, LauncherPage.routeName);
  }
}
