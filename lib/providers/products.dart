import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  var _showFavourites = false;

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  List<Product> get products {
    if (_showFavourites)
      return _products.where((element) => element.isFavourite).toList();
    return [..._products];
  }

  void showFavouritesOnly() {
    _showFavourites = true;
    notifyListeners();
  }

  void showAll() {
    _showFavourites = false;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://myshop-c35d9-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFavourite: value['isFavourite'],
            imageUrl: value['imageUrl']));
      });
      _products = loadedProducts;
      notifyListeners();
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://myshop-c35d9-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      //error thrown
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final url = Uri.parse(
        'https://myshop-c35d9-default-rtdb.firebaseio.com/products/$id.json');
    final prodIndex = _products.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price
          }));
      _products[prodIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final url = Uri.parse(
        'https://myshop-c35d9-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex =
        _products.indexWhere((element) => element.id == id);
    var existingProduct = _products[existingProductIndex];
    _products.removeAt(existingProductIndex);
    http.delete(url).then((value) {
      existingProduct = null;
    }).catchError((_) {
      _products.insert(existingProductIndex, existingProduct);
    });
    notifyListeners();
  }
}
