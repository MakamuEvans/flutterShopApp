import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourite() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
        'https://myshop-c35d9-default-rtdb.firebaseio.com/products/$id.json');
    try {
      final response = await http.patch(url, body: json.encode({
        'isFavourite': isFavourite
      }));
      if (response.statusCode >= 400)
        throw Exception(["hahahahaha"]);
    } catch(error){
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
