import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ecommerce_mobile/providers/cart.provider.dart';
import 'package:mini_ecommerce_mobile/models/product.model.dart';

void main() {
  group('CartProvider', () {
    late CartProvider cart;
    late Product p1, p2;

    setUp(() {
      cart = CartProvider();

      p1 = Product(
        id: 1,
        name: 'P1',
        price: 10,
        stock: 5,
        thumbnail: 'www.test.com',
      );

      p2 = Product(
        id: 2,
        name: 'P2',
        price: 20,
        stock: 10,
        thumbnail: 'www.test.com',
      );
    });

    // addProduct()
    test('Adding same product increases quantity', () {
      expect(cart.isEmpty, isTrue);

      cart.addProduct(p1);
      expect(cart.items.first.quantity, 1);

      cart.addProduct(p1);
      expect(cart.items.first.quantity, 2);
    });

    test('Removing product decrements quantity', () {
      cart.addProduct(p1);
      cart.addProduct(p1);
      cart.addProduct(p1);
      cart.addProduct(p1);
      expect(cart.items.first.quantity, 4);

      cart.removeProduct(p1);
      expect(cart.items.first.quantity, 3);
    });

    test('Removing product when quantity is 1 removes product', () {
      cart.addProduct(p2);
      cart.removeProduct(p2);

      expect(cart.items.isEmpty, isTrue);
    });

    test('Calculatin finance', () {
      cart.addProduct(p1);
      cart.addProduct(p2);
      cart.addProduct(p2);

      expect(cart.subtotal, 50);
      expect(cart.tax, 5);
      expect(cart.total, 55);
    });

    // clear()
    test('clearing', () {
      cart.addProduct(p1);
      expect(cart.items.isNotEmpty, isTrue);
      cart.clear();
      expect(cart.items.isEmpty, isTrue);
    });
  });
}
