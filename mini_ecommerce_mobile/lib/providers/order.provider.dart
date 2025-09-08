import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mini_ecommerce_mobile/models/Order.model.dart';
import 'package:mini_ecommerce_mobile/utils/apiRequests.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool isLoading = false;
  String? error;

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> loadOrders(String token) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await ApiRequests.get('/orders/me', token: token);

      if (res.statusCode == 200) {
        final List data = res.body.isNotEmpty ? jsonDecode(res.body) : [];
        _orders = data.map((e) => Order.fromJson(e)).toList();
      } else {
        error = 'Failed to load orders: ${res.statusCode}';
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
