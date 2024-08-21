import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      if (mounted) {
        ErrorDialog.show(context, AppLocalizations.of(context)!.scanError);
      }
    }
    if (!mounted) return;
    if (scanResult != '-1') {
      Navigator.pop(context, scanResult);
    } else {
      if (mounted) {
        setState(() {
          this.scanResult = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.scanBarcode),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: scanBarcode,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(AppLocalizations.of(context)!.startScan),
            ),
          ],
        ),
      ),
    );
  }
}
