import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

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
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {total = total + (value.price * value.quantity);});
    return total;
  }

  void addItem(Product product){
    if(_items.containsKey(product.id)){
      _items.update(product.id, (oldCart) => CartItem(id: oldCart.id, title: oldCart.title, quantity: oldCart.quantity + 1, price: oldCart.price));
    } else {
      _items.putIfAbsent(product.id, () => CartItem(id: DateTime.now().toString(), title: product.title, quantity: 1, price: product.price));
    }
    notifyListeners();
  }

  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }
}
