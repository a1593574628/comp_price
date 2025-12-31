import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/price_provider.dart';
import 'product_detail_screen.dart';
import 'add_price_screen.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final barcode = _controller.text.trim();
      final provider = Provider.of<PriceProvider>(context, listen: false);
      
      await provider.scanProduct(barcode);

      if (mounted) {
        if (provider.scannedProduct != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ProductDetailScreen(),
            ),
          );
        } else {
          // Product not found, go to add screen with barcode
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AddPriceScreen(barcode: barcode, isNewProduct: true),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('手動輸入條碼')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: '條碼',
                  hintText: '請輸入商品條碼',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '請輸入條碼';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('確認'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
