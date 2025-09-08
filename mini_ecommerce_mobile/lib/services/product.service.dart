import '../models/product.model.dart';
import 'dart:convert';
import '../utils/apiRequests.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<List<Product>> fetchProducts(String token) async {
    final http.Response res = await ApiRequests.get('/products', token: token);

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products (${res.statusCode})');
    }
  }
}
