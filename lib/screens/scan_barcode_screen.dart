import 'package:flutter/material.dart';
import 'package:asset_manager/l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets/util/error_dialog.dart';

class ScanBarcodeScreen extends StatefulWidget {
  static const id = 'barcode_screen';

  const ScanBarcodeScreen({super.key});

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.scanBarcode),
        centerTitle: true,
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          if (_scanned) return;
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            _scanned = true;
            Navigator.pop(context, barcodes.first.rawValue);
          }
        },
      ),
    );
  }
}
