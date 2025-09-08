import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.model.dart';
import '../providers/cart.provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: widget.product.thumbnail.isNotEmpty
                  ? Image.network(
                      widget.product.thumbnail,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Color.fromARGB(255, 105, 104, 104),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(widget.product.name,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("\$${widget.product.price.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            widget.product.stock == 0
                ? const Text("Out of stock",
                    style: TextStyle(color: Colors.red, fontSize: 16))
                : Text("Available stock: ${widget.product.stock}"),
            const SizedBox(height: 16),
            if (widget.product.stock > 0)
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                      icon: const Icon(Icons.remove)),
                  Text(quantity.toString(),
                      style: const TextStyle(fontSize: 18)),
                  IconButton(
                      onPressed: () {
                        if (quantity < widget.product.stock) {
                          setState(() => quantity++);
                        }
                      },
                      icon: const Icon(Icons.add)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      for (int i = 0; i < quantity; i++) {
                        cart.addProduct(widget.product);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$quantity pieces added to cart'),
                        ),
                      );
                    },
                    child: const Text("Add to Cart"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
