import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/price_provider.dart';
import 'add_price_screen.dart';
import 'home_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PriceProvider>(
      builder: (context, provider, child) {
        final product = provider.scannedProduct;
        final prices = provider.priceEntries;

        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('無資料')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('商品詳情'),
            actions: [
               IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('條碼: ${product.barcode}'),
                const SizedBox(height: 20),
                Text(
                  '價格紀錄',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: prices.length,
                    itemBuilder: (context, index) {
                      final priceInfo = prices[index];
                      return Card(
                        child: ListTile(
                          title: Text('${priceInfo.price} 元'),
                          subtitle: Text('${priceInfo.store}\n${DateFormat('yyyy-MM-dd HH:mm').format(priceInfo.date)}'),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddPriceScreen(
                    barcode: product.barcode,
                    isNewProduct: false,
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
            tooltip: '新增價格',
          ),
        );
      },
    );
  }
}
