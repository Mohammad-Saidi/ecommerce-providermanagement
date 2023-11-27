import 'package:ecom_basic_user/models/order_expansion_item.dart';
import 'package:flutter/material.dart';

class OrderExpansionBodyView extends StatelessWidget {
  final OrderExpansionBody body;

  const OrderExpansionBodyView({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: body.productDetails
            .map((e) => ListTile(
                  title: Text(e.productModel.productName),
                  trailing: Text(
                    '${e.quantity}x${e.productModel.calculatePriceAfterDiscount()}',
                    style: const TextStyle(fontSize: 18,),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
