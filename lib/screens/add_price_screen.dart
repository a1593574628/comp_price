import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/price_provider.dart';
import 'product_detail_screen.dart';

class AddPriceScreen extends StatefulWidget {
  final String barcode;
  final bool isNewProduct;

  const AddPriceScreen({
    super.key,
    required this.barcode,
    required this.isNewProduct,
  });

  @override
  State<AddPriceScreen> createState() => _AddPriceScreenState();
}

class _AddPriceScreenState extends State<AddPriceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _storeController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isNewProduct) {
      final provider = Provider.of<PriceProvider>(context, listen: false);
      if (provider.scannedProduct != null) {
        _nameController.text = provider.scannedProduct!.name;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _storeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<PriceProvider>(context, listen: false);
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final store = _storeController.text;

      if (widget.isNewProduct) {
        final name = _nameController.text;
        await provider.addProductAndPrice(widget.barcode, name, store, price);
      } else {
        await provider.addPriceOnly(widget.barcode, store, price);
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ProductDetailScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewProduct ? '建立新商品' : '新增價格'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('條碼: ${widget.barcode}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '商品名稱'),
                enabled: widget.isNewProduct, 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入商品名稱';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _storeController,
                decoration: const InputDecoration(labelText: '通路地點 (店家)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入通路地點';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: '價格'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入價格';
                  }
                  if (double.tryParse(value) == null) {
                    return '請輸入有效的數字';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('儲存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
