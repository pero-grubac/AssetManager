import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../widgets/util/error_dialog.dart';

class ScanBarcodeScreen extends StatefulWidget {
  static const id = 'barcode_screen';

  const ScanBarcodeScreen({super.key});

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  String? scanResult;

  Future<void> scanBarcode() async {
    String? scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Convert color to string
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      ErrorDialog.show(context, 'Error scanning barcode.');
    }
    if (!mounted) return;
    setState(() {
      this.scanResult = scanResult;
    });
    print(scanResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: scanBarcode,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Start Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
