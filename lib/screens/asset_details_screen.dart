import 'package:asset_manager/models/asset.dart';
import 'package:flutter/material.dart';

import '../widgets/util/build_text_field.dart';

class AssetDetailsScreen extends StatefulWidget {
  const AssetDetailsScreen({
    super.key,
    this.onSaveAsset,
    this.asset,
    this.isEditable = true,
  });
  final Asset? asset;
  final void Function(Asset worker)? onSaveAsset;
  final bool isEditable;

  @override
  State<AssetDetailsScreen> createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends State<AssetDetailsScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();
  // TODO date picker
  @override
  void initState() {
    super.initState();
    if (widget.asset != null) {
      _nameController.text = widget.asset!.name;
      _descriptionController.text = widget.asset!.description;
      _barcodeController.text = widget.asset!.barcode.toString();
      _priceController.text = widget.asset!.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _submitData() {
    final enteredName = _nameController.text.trim();
    final enteredDescription = _descriptionController.text.trim();
    double? enteredPrice = double.tryParse(_priceController.text.trim());
    int? enteredBarcode = int.tryParse(_barcodeController.text.trim());
    if (enteredPrice == null || enteredBarcode == null) return;
    try {
      Asset asset;
      if (widget.asset == null) {
        asset = Asset(
          name: enteredName,
          description: enteredDescription,
          barcode: enteredBarcode,
          price: enteredPrice,
          creationDate: DateTime.now(),
          assignedPersonId: 'assignedPersonId',
          assignedLocationId: 'assignedLocationId',
          imagePath: 'imagePath',
        );
      } else {
        asset = Asset(
          id: widget.asset!.id,
          name: enteredName,
          description: enteredDescription,
          barcode: enteredBarcode,
          price: enteredPrice,
          creationDate: DateTime.now(),
          assignedPersonId: 'assignedPersonId',
          assignedLocationId: 'assignedLocationId',
          imagePath: 'imagePath',
        );
      }
      widget.onSaveAsset!(asset);
      Navigator.pop(context);
    } catch (e) {
      if (e is ArgumentError) {
        _showErrorDialog(e.message);
      } else {
        _showErrorDialog('An unknown error occurred');
      }
    }
  }

  List<Widget> _buildTextFields({required bool isWideScreen}) {
    final nameTextField = BuildTextField(
      controller: _nameController,
      label: 'Name',
      isEditable: !widget.isEditable,
    );
    final descriptionTextField = BuildTextField(
      controller: _descriptionController,
      label: 'Description',
      isEditable: !widget.isEditable,
    );
    final barcodeTextField = BuildTextField(
      controller: _barcodeController,
      label: 'Barcode',
      isEditable: !widget.isEditable,
    );
    final priceTextField = BuildTextField(
      controller: _priceController,
      label: 'Price',
      isEditable: !widget.isEditable,
    );
    final barcodeIcon = Row(
      children: [
        Expanded(child: barcodeTextField),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () {
            // Define your QR code scanning functionality here
          },
        ),
      ],
    );
    final barcodeRow = widget.isEditable ? barcodeIcon : barcodeTextField;
    if (isWideScreen) {
      // TODO
      return [];
    } else {
      return [
        nameTextField,
        priceTextField,
        descriptionTextField,
        barcodeRow,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Details'),
        actions: widget.isEditable
            ? [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _submitData,
                ),
              ]
            : null,
      ),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: keyboardSpace),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildTextFields(isWideScreen: isWideScreen),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
