import 'package:ecom_basic_user/customwidgets/order_expansion_body_view.dart';
import 'package:ecom_basic_user/customwidgets/order_expansion_header_view.dart';
import 'package:ecom_basic_user/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_expansion_item.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'order_details_Page.dart';

class OrderPage extends StatefulWidget {
  static const String routeName = '/order';

  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderExpansionItem> items = [];

  @override
  void didChangeDependencies() {
    items =
        Provider.of<OrderProvider>(context, listen: false).getExpansionItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'),),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (index, isExpanded) {
            setState(() {
              items[index].isExpanded = !isExpanded;
            });
          },
          children: items
              .map((e) => ExpansionPanel(
                    headerBuilder: (context, isExpanded) =>
                        OrderExpansionHeaderView(header: e.header),
                    body: OrderExpansionBodyView(body: e.body),
                    isExpanded: e.isExpanded,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
