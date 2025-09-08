import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mini_ecommerce_mobile/providers/authentication.provider.dart';
import 'package:mini_ecommerce_mobile/utils/apiRequests.dart';
import 'package:provider/provider.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  bool _isLoading = true;
  String? _error;
  List _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      final res =
          await ApiRequests.get('/orders/admin/orders', token: auth.token!);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _orders = data;
        });
      } else if (res.statusCode == 401) {
        auth.logout();
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _error = 'Failed to load orders: ${res.statusCode}';
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      itemCount: _orders.length,
                      itemBuilder: (ctx, i) {
                        final order = _orders[i];
                        final items = order['items'] as List<dynamic>? ?? [];
                        final date =
                            DateTime.tryParse(order['createdAt'] ?? '');
                        final formattedDate = date != null
                            ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"
                            : order['createdAt'] ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order #${order['id']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total: \$${(order['totalAmount'] ?? 0.0).toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'Created: $formattedDate',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Divider(height: 16),
                                ...items.map((item) {
                                  final product = item['product'];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(product['name'] ?? '')),
                                        Text(
                                          '${item['quantity']} x \$${(item['price'] ?? 0.0).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
