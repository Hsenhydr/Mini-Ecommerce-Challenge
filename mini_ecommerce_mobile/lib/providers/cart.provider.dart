import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.model.dart';
import '../models/product.model.dart';
import '../utils/apirequests.dart';
import 'product.provider.dart';
import 'authentication.provider.dart';

class CartProvider extends ChangeNotifier {
  final List<Cart> _items = [];

  List<Cart> get items => List.unmodifiable(_items);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.1; // 10%
  double get total => subtotal + tax;
  bool get isEmpty => _items.isEmpty;

  void addProduct(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(Cart(product: product));
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity > 1
          ? _items[index].quantity--
          : _items.removeAt(index);
      notifyListeners();
    }
  }

  void removeItem(Cart item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<bool> placeOrder(String token, BuildContext context) async {
    if (_items.isEmpty) return false;

    final orderData = _items
        .map((i) => {
              'product': {'id': i.product.id},
              'quantity': i.quantity
            })
        .toList();

    try {
      final res = await ApiRequests.post('/orders', orderData, token: token);

      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (res.statusCode == 201) {
        clear();
        await productProvider.loadProducts(authProvider.token!);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Order placed successfully'),
        ));
        return true;
      } else if (res.statusCode == 400 ||
          res.statusCode == 409) // bad request/out of stock
      {
        await productProvider.loadProducts(authProvider.token!);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('some products are out of stock')));
        return false;
      } else if (res.statusCode == 401) {
        await authProvider.logout();
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Token expired')));
        return false;
      } else {
        debugPrint('Order failed. Status: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Order failed: $e');
    }
    return false;
  }
}
