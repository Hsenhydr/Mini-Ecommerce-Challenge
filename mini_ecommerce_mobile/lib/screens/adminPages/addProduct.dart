import 'package:flutter/material.dart';
import 'package:mini_ecommerce_mobile/providers/authentication.provider.dart';
import 'package:mini_ecommerce_mobile/utils/apiRequests.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = auth.token!;
    final body = {
      "name": _nameController.text.trim(),
      "price": double.parse(_priceController.text.trim()),
      "stock": int.parse(_stockController.text.trim()),
      "thumbnail": _thumbnailController.text.trim(),
    };

    try {
      final res = await ApiRequests.post('/products', body, token: token);
      if (res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${res.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator: (x) =>
                  x == null || x.isEmpty ? 'Enter product name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (x) {
                if (x == null || x.isEmpty) return 'Enter price';
                final price = double.tryParse(x);
                if (price == null || price < 0) return 'Enter valid price';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
              validator: (x) {
                if (x == null || x.isEmpty) return 'Enter stock';
                final stock = int.tryParse(x);
                if (stock == null || stock < 0) return 'Enter valid stock';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _thumbnailController,
              decoration: const InputDecoration(labelText: 'Thumbnail'),
              validator: (x) =>
                  x == null || x.isEmpty ? 'Enter Thumbanil URL' : null,
            ),
            const SizedBox(height: 24),
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitProduct,
                    child: const Text('Add Product'),
                  ),
          ],
        ),
      ),
    );
  }
}
