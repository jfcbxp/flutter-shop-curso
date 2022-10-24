import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/model/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = dotenv.env['BASE_URL'];
  List<Product> _items = [];
  bool _showFavoriteOnly = false;
  String? token;

  ProductList(this.token, this._items);

  List<Product> get items {
    return _showFavoriteOnly
        ? _items.where((prod) => prod.isFavorite).toList()
        : [..._items];
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        title: data['name'] as String,
        description: data['description'] as String,
        price: data['price'] as double,
        imageUrl: data['imageUrl'] as String,
        isFavorite: false);
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response =
        await get(Uri.parse('$_baseUrl/product.json?auth=${token}'));
    if (response.body == 'null') return;
    print(response);
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      _items.add(Product.fromJson(productData));
    });
    notifyListeners();
  }

  Future<void> loadProducts2() async {
    _items.clear();
    DatabaseReference products = FirebaseDatabase.instance.ref('product');
    final snapshot = await products.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> productMap =
          snapshot.value as Map<dynamic, dynamic>;
      productMap.forEach((key, value) {
        final productJson = jsonEncode(value);
        Map<String, dynamic> data = jsonDecode(productJson);
        _items.add(Product.fromJson(data));
      });
    }

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final future = post(Uri.parse('$_baseUrl/product.json?auth=${token}'),
        body: jsonEncode(product));

    return future.then<void>((response) {
      _items.add(product);
      notifyListeners();
    });
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      final future = patch(
          Uri.parse('$_baseUrl/product/${product.id}.json?auth=${token}'),
          body: jsonEncode(product));

      return future.then<void>((response) {
        _items[index] = product;
        notifyListeners();
      });
    }
  }

  void removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      await delete(
          Uri.parse('$_baseUrl/product/${product.id}.json?auth=${token}'));
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Product product) async {
    final isFavorite = product.isFavorite = !product.isFavorite;
    final future = patch(
      Uri.parse('$_baseUrl/product/${product.id}.json?auth=${token}'),
      body: jsonEncode({"isFavorite": isFavorite}),
    );

    return future.then<void>((response) {
      product.isFavorite = isFavorite;
      notifyListeners();
    });
  }

  int get itemsCount {
    return _items.length;
  }
}
