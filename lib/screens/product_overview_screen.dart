import 'package:Store_APP/providers/products.dart';

import '../screens/app_drawer.dart';

import '../screens/cart_Screen.dart';

import '../providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions { Favorites, All }

class ProudctOverviewScreen extends StatefulWidget {
  @override
  _ProudctOverviewScreenState createState() => _ProudctOverviewScreenState();
}

class _ProudctOverviewScreenState extends State<ProudctOverviewScreen> {
  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndSetProducts(); will not work !!
    // Future.delayed(Duration.zero).then((value) => (_){
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });

    super.initState();
  }

  var _isLoading = false;
  var _isinit = true;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isinit = false;

    super.didChangeDependencies();
  }

  var _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _isFavorite = true;
                  } else {
                    _isFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text("Only Favorites"),
                        value: FilterOptions.Favorites),
                    PopupMenuItem(
                        child: Text("Show All"), value: FilterOptions.All),
                  ]),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                  child: ch,
                  value: cart.itemCount
                      .toString()), // i used consumer here just to this widget only rebuilt when cart changesi put the icon outside the builder just to not rebuilt when cart change cause i don't need to be rebuilted
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_isFavorite),
    );
  }
}
