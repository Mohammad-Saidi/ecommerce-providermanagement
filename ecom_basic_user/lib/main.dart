import 'package:ecom_basic_user/pages/launcher_page.dart';
import 'package:ecom_basic_user/pages/login_page.dart';
import 'package:ecom_basic_user/pages/order_details_Page.dart';
import 'package:ecom_basic_user/pages/order_page.dart';
import 'package:ecom_basic_user/pages/product_details_page.dart';
import 'package:ecom_basic_user/pages/view_product_page.dart';
import 'package:ecom_basic_user/providers/cart_provider.dart';
import 'package:ecom_basic_user/providers/order_provider.dart';
import 'package:ecom_basic_user/providers/product_provider.dart';
import 'package:ecom_basic_user/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
import 'pages/order_successful_page.dart';
import 'pages/user_profile_page.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider(),),
        ChangeNotifierProvider(create: (context) => OrderProvider(),),
        ChangeNotifierProvider(create: (context) => UserProvider(),),
        ChangeNotifierProvider(create: (context) => CartProvider(),),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildShrineTheme() {
    final ThemeData base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: kShrinePink400,
        onPrimary: kShrineBrown900,
        secondary: kShrineBrown900,
        error: kShrineErrorRed,
      ),
      textTheme: _buildShrineTextTheme(GoogleFonts.ralewayTextTheme()),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: kShrinePink100,
      ),
    );
  }

  TextTheme _buildShrineTextTheme(TextTheme base) {
    return base
        .copyWith(
      headlineSmall: base.headlineSmall!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      titleLarge: base.titleLarge!.copyWith(
        fontSize: 18.0,
      ),
      bodySmall: base.bodySmall!.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
      bodyLarge: base.bodyLarge!.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),

    ).apply(
      displayColor: kShrineBrown900,
      bodyColor: kShrineBrown900,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _buildShrineTheme(),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => const LauncherPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        ViewProductPage.routeName: (_) => const ViewProductPage(),
        ProductDetailsPage.routeName: (_) => const ProductDetailsPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        UserProfilePage.routeName: (_) => const UserProfilePage(),
        OrderDetailsPage.routeName: (_) => const OrderDetailsPage(),
        CheckoutPage.routeName: (_) => const CheckoutPage(),
        CartPage.routeName: (_) => const CartPage(),
        OrderSuccessfulPage.routeName: (_) => const OrderSuccessfulPage(),
      },
    );
  }
}

