import 'package:flutter/material.dart';
import 'package:mini_ecommerce_mobile/screens/productDetails.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.provider.dart';
import '../providers/product.provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadProducts(auth.token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Navigator.pushNamed(context, '/orders'),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: productProvider.isLoading
          ? GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75),
              itemCount: 6,
              itemBuilder: (ctx, i) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
            )
          : productProvider.error != null
              ? Center(child: Text(productProvider.error!))
              : RefreshIndicator(
                  onRefresh: () => productProvider.loadProducts(auth.token!),
                  child: productProvider.products.isEmpty
                      ? const Center(child: Text("No products available"))
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.75),
                          itemCount: productProvider.products.length,
                          itemBuilder: (ctx, i) {
                            final product = productProvider.products[i];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetails(product: product)),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: product.thumbnail.isNotEmpty
                                          ? Image.network(
                                              product.thumbnail,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                      progress) =>
                                                  progress == null
                                                      ? child
                                                      : Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.grey[100]!,
                                                          child: Container(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                              //  eza not working link
                                              errorBuilder: (_, __, ___) =>
                                                  const Center(
                                                      child: Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: Colors.grey,
                                              )),
                                            )
                                          : const Center(
                                              child: Icon(
                                              Icons.image,
                                              size: 50,
                                              color: Colors.grey,
                                            )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                          "\$${product.price.toStringAsFixed(2)}"),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: product.stock > 0
                                            ? Text("Stock: ${product.stock}")
                                            : Chip(
                                                label:
                                                    const Text("Out of stock"),
                                                backgroundColor:
                                                    Colors.red[200],
                                              )),
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
