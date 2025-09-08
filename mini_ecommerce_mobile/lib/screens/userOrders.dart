import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.provider.dart';
import '../utils/apirequests.dart';

class UserOrdersPage extends StatefulWidget {
  const UserOrdersPage({super.key});

  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  bool isLoading = true;
  String? error;
  List orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final res = await ApiRequests.get('/orders/me', token: auth.token!);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          orders = data;
        });
      } else if (res.statusCode == 403) {
        setState(() {
          error = 'Forbidden: ${res.statusCode}';
        });
      } else {
        setState(() {
          error = 'Failed to load orders: ${res.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!))
                : orders.isEmpty
                    ? const Center(child: Text('No past orders'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        itemCount: orders.length,
                        itemBuilder: (ctx, i) {
                          final order = orders[i];
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
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${order['id']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child:
                                                  Text(product['name'] ?? '')),
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
      ),
    );
  }
}
