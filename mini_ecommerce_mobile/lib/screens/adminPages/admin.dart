import 'package:flutter/material.dart';
import 'package:mini_ecommerce_mobile/providers/authentication.provider.dart';
import 'package:mini_ecommerce_mobile/screens/adminPages/addProduct.dart';
import 'package:mini_ecommerce_mobile/screens/adminPages/allOrders.dart';
import 'package:mini_ecommerce_mobile/screens/adminPages/lowStock.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = const [
    Tab(text: 'Add Product'),
    Tab(text: 'All Orders'),
    Tab(text: 'Low Stock'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AddProductScreen(),
          AllOrdersScreen(),
          LowStockScreen(),
        ],
      ),
    );
  }
}
