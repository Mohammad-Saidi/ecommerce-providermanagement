import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_basic_user/providers/cart_provider.dart';
import 'package:ecom_basic_user/providers/user_provider.dart';
import 'package:ecom_basic_user/utils/colors.dart';
import 'package:ecom_basic_user/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../customwidgets/image_holder_view.dart';
import '../models/image_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productdetails';

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late ProductProvider productProvider;
  double userRating = 0.0;

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 200,
            imageUrl: productModel.thumbnailImage.downloadUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Consumer<CartProvider>(
              builder: (context, provider, child) {
                final isInCart = provider.isProductInCart(productModel.productId!);
                return ElevatedButton.icon(
                  onPressed: () {
                    if(isInCart) {
                      provider.removeFromCart(productModel.productId!);
                    } else {
                      provider.addToCart(productModel);
                    }
                  },
                  icon: Icon(isInCart ? Icons.remove_shopping_cart : Icons.shopping_cart),
                  label: Text(isInCart ? 'REMOVE FROM CART' : 'ADD TO CART'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart ? kShrineBrown900 : kShrinePink400,
                      foregroundColor: isInCart ? kShrinePink100 : kShrinePink50
                  ),

                );
              },
            ),
          ),
          if(productModel.additionalImages.isNotEmpty) SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Card(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                children: productModel.additionalImages.map((e) => ImageHolderView(
                  imageModel: e,
                  onImagePressed: () {
                    _showImageOnDialog(e);
                  },
                )).toList(),
              ),
            ),
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title: Text('Sale Price: $currencySymbol${productModel.salePrice}'),
            subtitle: Text('Stock: ${productModel.stock}'),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RatingBar.builder(
                    initialRating: 0.0,
                    minRating: 0.0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (value) {
                      userRating = value;
                    },
                  ),
                  OutlinedButton(
                    onPressed: rateThisProduct,
                    child: const Text('SUBMIT'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showImageOnDialog(ImageModel image) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: CachedNetworkImage(
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height / 2,
                imageUrl: image.downloadUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ));
  }


  void rateThisProduct() async {
    EasyLoading.show(status: 'Please wait');
    final userModel = Provider.of<UserProvider>(context, listen: false).userModel;
    await productProvider.addRating(productModel.productId!, userModel!, userRating);
    EasyLoading.dismiss();
    showMsg(context, 'Thanks for your rating');
  }
}
