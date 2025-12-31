import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../models/price_entry.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<void> createProduct(Product product) async {
    await _client.from('products').upsert(product.toMap());
  }

  Future<Product?> readProduct(String barcode) async {
    final response = await _client
        .from('products')
        .select()
        .eq('barcode', barcode)
        .maybeSingle();

    if (response != null) {
      return Product.fromMap(response);
    }
    return null;
  }

  Future<void> createPriceEntry(PriceEntry entry) async {
    // Supabase will generate the ID, so we don't include it in insert if it's null
    final data = entry.toMap();
    if (data['id'] == null) {
      data.remove('id');
    }
    await _client.from('prices').insert(data);
  }

  Future<List<PriceEntry>> readPriceEntries(String barcode) async {
    final response = await _client
        .from('prices')
        .select()
        .eq('barcode', barcode)
        .order('date', ascending: false);

    final List<dynamic> data = response;
    return data.map((json) => PriceEntry.fromMap(json)).toList();
  }
}
