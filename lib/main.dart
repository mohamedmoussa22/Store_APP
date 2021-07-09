import 'package:Store_APP/screens/edit_product.dart';

import './screens/user_products_screen.dart';

import './screens/orders_screen.dart';

import './providers/orders.dart';

import './screens/cart_Screen.dart';

import './providers/cart.dart';
import 'package:flutter/material.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import 'providers/products.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // i used this if any change happned to Products object the widgets that lisetening will be updated and rebuilt with new data
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders())
      ],
      child: MaterialApp(
        title: "MyShop",
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProudctOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeNmae: (context) => OrderScreen(),
          UserScreenProduct.routeName: (context) => UserScreenProduct(),
          EditProdcutScreen.routeName: (context) => EditProdcutScreen()
        },
      ),
    );
  }
}
