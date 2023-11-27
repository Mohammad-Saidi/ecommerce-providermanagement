import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_basic_user/customwidgets/cart_bubble_view.dart';
import 'package:ecom_basic_user/customwidgets/main_drawer.dart';
import 'package:ecom_basic_user/customwidgets/product_grid_item_view.dart';
import 'package:ecom_basic_user/pages/product_details_page.dart';
import 'package:ecom_basic_user/providers/order_provider.dart';
import 'package:ecom_basic_user/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {

  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<OrderProvider>(context, listen: false).getMyOrders();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Products'),
        actions: const [
          CartBubbleView(),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7
          ),
          itemCount: provider.productList.length,
          itemBuilder: (context, index) {
            final product = provider.productList[index];
            return ProductGridItemView(productModel: product,);
          },
        ),
      ),
    );
  }
}
