class Product {
  final String barcode;
  final String name;

  Product({required this.barcode, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'name': name,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      barcode: map['barcode'],
      name: map['name'],
    );
  }
}
