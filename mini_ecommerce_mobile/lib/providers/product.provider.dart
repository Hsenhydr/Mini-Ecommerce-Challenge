import 'package:flutter/foundation.dart';
import '../models/product.model.dart';
import '../services/product.service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _loading = false;
  String? error;

  List<Product> get products => _products;
  bool get isLoading => _loading;

  Future<void> loadProducts(String token) async {
    _loading = true;
    error = null;
    notifyListeners();
    try {
      _products = await ProductService.fetchProducts(token);
    } catch (e) {
      error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
