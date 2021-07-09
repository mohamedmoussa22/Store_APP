import 'package:flutter/material.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  ProductsGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final prodctsData = Provider.of<Products>(
        context); // kda hwa hybos 3la lapraent widget 3shan yshof al class aly na 3ayz access o fa hykhrog yla'eni 3amel fe al  main ChangeNotifyProvider() w 3amel fe al create class products
    // i used Provider.of<Products>(context) so i can create an object from Products so i can access the data inside this class and if any data change in this class then Widgets that listen will rebuilt
    final products = showFav ? prodctsData.favorites : prodctsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            // you must use ChangeNotifierProvider.value in cases like you build widgets from lists cause widgets that didn't yet build but will be when you scroll have data if you used ChangeNotifierProvider with builder method that willl not correctly
            value: products[index],
            child: ProductItem(
                /* products[index].id, products[index].title,
                products[index].imageUrl */
                ),
          );
        });
  }
}
