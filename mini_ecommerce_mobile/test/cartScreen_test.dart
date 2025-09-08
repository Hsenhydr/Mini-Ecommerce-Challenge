import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ecommerce_mobile/providers/authentication.provider.dart';
import 'package:provider/provider.dart';
import 'package:mini_ecommerce_mobile/providers/cart.provider.dart';
import 'package:mini_ecommerce_mobile/models/product.model.dart';
import 'package:mini_ecommerce_mobile/screens/cart.dart';

// testing cart widget cz already provider is tested
void main() {
  testWidgets('Cart shows data', (WidgetTester tester) async {
    final cart = CartProvider();

    final product = Product(
      id: 1,
      name: "P1",
      price: 10,
      stock: 5,
      thumbnail: "",
    );
    cart.addProduct(product);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CartProvider>.value(value: cart),
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(),
          ),
        ],
        child: const MaterialApp(
          home: CartScreen(),
        ),
      ),
    );

    expect(find.text("P1"), findsOneWidget);
    expect(find.textContaining("Subtotal"), findsOneWidget);
    expect(find.textContaining("Total"), findsOneWidget);
    expect(find.text("Place Order"), findsOneWidget);
  });
}
