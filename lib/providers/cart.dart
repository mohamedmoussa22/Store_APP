import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void addItem(String productID, double price, String title) {
    if (_items.containsKey(productID)) {
      //change Quantity
      _items.update(
          // update serch for product ID and pass it as an parameter to fuction then you can replace it with new object
          productID,
          (oldValue) => CartItem(
              id: oldValue.id,
              title: oldValue.title,
              quantity: oldValue.quantity + 1,
              price: oldValue.price));
    } else {
      _items.putIfAbsent(
          productID,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (oldValue) => CartItem(
              id: oldValue.id,
              title: oldValue.title,
              quantity: oldValue.quantity - 1,
              price: oldValue.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
