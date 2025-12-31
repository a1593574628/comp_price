import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/price_provider.dart';
import 'product_detail_screen.dart';
import 'add_price_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('掃描條碼')),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) async {
          if (_isScanned) return;
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            String? code = barcodes.first.rawValue;
            if (code != null) {
              setState(() {
                _isScanned = true;
              });
              
              final provider = Provider.of<PriceProvider>(context, listen: false);
              await provider.scanProduct(code);

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
                       builder: (context) => AddPriceScreen(barcode: code, isNewProduct: true),
                     ),
                   );
                 }
              }
            }
          }
        },
      ),
    );
  }
}
