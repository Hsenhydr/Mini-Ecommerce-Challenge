import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mini_ecommerce_mobile/providers/authentication.provider.dart';
import 'package:mini_ecommerce_mobile/utils/apiRequests.dart';
import 'package:provider/provider.dart';

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  _LowStockScreenState createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  bool _isLoading = true;
  String? _error;
  List _products = [];

  @override
  void initState() {
    super.initState();
    _loadLowStockProducts();
  }

  Future<void> _loadLowStockProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      final res =
          await ApiRequests.get('/products/admin/lowstock', token: auth.token!);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _products = data;
        });
      } else if (res.statusCode == 401) {
        auth.logout();
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _error = 'Failed to load products: ${res.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildProductCard(Map product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2,
      child: ListTile(
        title: Text(product['name'] ?? ''),
        subtitle: Text('Stock: ${product['stock']}'),
        trailing: Text(
          '\$${(product['price'] ?? 0.0).toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadLowStockProducts,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _products.isEmpty
                  ? const Center(child: Text('No products having low nstock'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _products.length,
                      itemBuilder: (ctx, i) => _buildProductCard(_products[i]),
                    ),
    );
  }
}
