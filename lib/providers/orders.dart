import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({@required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get orders {
    return [..._orderItems];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://myshop-c35d9-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    final List<OrderItem> items = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null)
      return;
    extractedData.forEach((key, value) {
      items.add(OrderItem(id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map((e) =>
              CartItem(id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price']))
              .toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });
    _orderItems = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = Uri.parse(
        'https://myshop-c35d9-default-rtdb.firebaseio.com/orders.json');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': products
              .map((e) =>
          {
            'id': e.id,
            'title': e.title,
            'quantity': e.quantity,
            'price': e.price
          })
              .toList(),
        }));
    _orderItems.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: products,
            dateTime: timestamp));
    notifyListeners();
  }
}
