import 'product.model.dart';

class OrderItem {
  final Product product;
  final int quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };
}

class Order {
  final int id;
  final DateTime date;
  final double total;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return Order(
      id: json['id'],
      date: DateTime.parse(json['date']),
      total: (json['total'] as num).toDouble(),
      items: itemsJson.map((i) => OrderItem.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'total': total,
        'items': items.map((i) => i.toJson()).toList(),
      };
}
