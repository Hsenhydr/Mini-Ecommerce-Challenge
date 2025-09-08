class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String thumbnail;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'stock': stock,
        'thumbnail': thumbnail,
      };
}
