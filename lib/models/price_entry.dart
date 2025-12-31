class PriceEntry {
  final int? id;
  final String barcode;
  final String store;
  final double price;
  final DateTime date;

  PriceEntry({
    this.id,
    required this.barcode,
    required this.store,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'store': store,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  factory PriceEntry.fromMap(Map<String, dynamic> map) {
    return PriceEntry(
      id: map['id'],
      barcode: map['barcode'],
      store: map['store'],
      price: map['price'],
      date: DateTime.parse(map['date']),
    );
  }
}
