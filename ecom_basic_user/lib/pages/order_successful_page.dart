import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatefulWidget {
  static const String routeName = '/successful';
  const OrderSuccessfulPage({Key? key}) : super(key: key);

  @override
  State<OrderSuccessfulPage> createState() => _OrderSuccessfulPageState();
}

class _OrderSuccessfulPageState extends State<OrderSuccessfulPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placed'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.done,
              size: 150,
              color: Colors.green,
            ),
            Text('Your order has been placed.', style: Theme.of(context).textTheme.titleLarge,),
          ],
        ),
      ),
    );
  }
}
