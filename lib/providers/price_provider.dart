import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/price_entry.dart';
import '../services/supabase_service.dart';

class PriceProvider with ChangeNotifier {
  final _supabaseService = SupabaseService();
  Product? _scannedProduct;
  List<PriceEntry> _priceEntries = [];
  bool _isLoading = false;

  Product? get scannedProduct => _scannedProduct;
  List<PriceEntry> get priceEntries => _priceEntries;
  bool get isLoading => _isLoading;

  Future<void> scanProduct(String barcode) async {
    _isLoading = true;
    notifyListeners();

    _scannedProduct = await _supabaseService.readProduct(barcode);
    if (_scannedProduct != null) {
      _priceEntries =
          await _supabaseService.readPriceEntries(barcode);
    } else {
      _priceEntries = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProductAndPrice(
      String barcode, String name, String store, double price) async {
    _isLoading = true;
    notifyListeners();

    Product product = Product(barcode: barcode, name: name);
    await _supabaseService.createProduct(product);

    PriceEntry entry = PriceEntry(
      barcode: barcode,
      store: store,
      price: price,
      date: DateTime.now(),
    );
    await _supabaseService.createPriceEntry(entry);

    // Refresh data
    await scanProduct(barcode);
  }

  Future<void> addPriceOnly(
      String barcode, String store, double price) async {
    _isLoading = true;
    notifyListeners();

    PriceEntry entry = PriceEntry(
      barcode: barcode,
      store: store,
      price: price,
      date: DateTime.now(),
    );
    await _supabaseService.createPriceEntry(entry);

    // Refresh data
    await scanProduct(barcode);
  }
  
  void clearScannedProduct() {
    _scannedProduct = null;
    _priceEntries = [];
    notifyListeners();
  }
}
