import '../screens/app_drawer.dart';

import '../widgets/order_item.dart' as ORd;

import '../providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeNmae = "OrderScreen";
  @override
  Widget build(BuildContext context) {
    final orderObj = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: ListView.builder(
          itemCount: orderObj.orders.length,
          itemBuilder: (ctx, index) => ORd.OrderItem(orderObj.orders[index])),
    );
  }
}
