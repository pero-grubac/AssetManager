import 'dart:io';

import 'package:asset_manager/models/asset.dart';
import 'package:asset_manager/widgets/image/image_input.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/util/build_text_field.dart';
import '../widgets/util/error_dialog.dart';
import '../widgets/util/helper_widgets.dart';

class AssetDetailsScreen extends StatefulWidget {
  const AssetDetailsScreen({
    super.key,
    this.onSaveAsset,
    this.asset,
    this.isEditable = true,
  });
  final Asset? asset;
  final Future<void> Function(Asset asset)? onSaveAsset;
  final bool isEditable;

  @override
  State<AssetDetailsScreen> createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends State<AssetDetailsScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();
  final _workerController = TextEditingController();

  File? _selectedImage;

  DateTime? _selectedDate;
  String? _pickedDate;
  @override
  void initState() {
    super.initState();
    if (widget.asset != null) {
      // Editing an existing asset
      _nameController.text = widget.asset!.name;
      _descriptionController.text = widget.asset!.description;
      _barcodeController.text = widget.asset!.barcode.toString();
      _priceController.text = widget.asset!.price.toString();
      _selectedImage = widget.asset?.image;
      _selectedDate = widget.asset?.creationDate;
      _pickedDate = widget.asset?.formatedDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _workerController.dispose();
    super.dispose();
  }

  void _submitData() {
    final enteredName = _nameController.text.trim();
    final enteredDescription = _descriptionController.text.trim();
    double? enteredPrice = double.tryParse(_priceController.text.trim());
    int? enteredBarcode = int.tryParse(_barcodeController.text.trim());
    if (enteredPrice == null) {
      ErrorDialog.show(context, 'Price  can not be empty');
      return;
    }
    if (enteredBarcode == null) {
      ErrorDialog.show(context, 'Barcode  can not be empty');
      return;
    }
    if (_selectedImage == null) {
      ErrorDialog.show(context, 'Image  can not be empty');
      return;
    }

    if (_selectedDate == null) {
      ErrorDialog.show(context, 'Date  can not be empty');
      return;
    }

    try {
      Asset asset;
      if (widget.asset == null) {
        asset = Asset(
          name: enteredName,
          description: enteredDescription,
          barcode: enteredBarcode,
          price: enteredPrice,
          creationDate: _selectedDate!,
          image: _selectedImage!,
        );
      } else {
        asset = Asset(
          id: widget.asset!.id,
          name: enteredName,
          description: enteredDescription,
          barcode: enteredBarcode,
          price: enteredPrice,
          creationDate: _selectedDate!,
          image: _selectedImage!,
        );
      }

      widget.onSaveAsset!(asset);

      Navigator.pop(context);
    } catch (e) {
      if (e is ArgumentError) {
        ErrorDialog.show(context, e.message);
      } else {
        ErrorDialog.show(context, 'An unknown error occurred ');
      }
    }
  }

  void _presentDatePicker() {
    final now = DateTime.now();
    final firstDate = DateTime(1900);
    final lastDate = now;
    showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: now,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _pickedDate = DateFormat('dd.MM.yyyy').format(_selectedDate!);
      });
    });
  }

  void _barcodeOverlay() {
    if (_barcodeController.text.isEmpty) {
      ErrorDialog.show(context, 'No barcode data available.');
      return;
    }

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Your barcode: ${_barcodeController.text}',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              addVerticalSpace(20),
              Card(
                color: Colors.white,
                elevation: 10,
                shadowColor: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarcodeWidget(
                    data: _barcodeController.text,
                    barcode: Barcode.code128(),
                    width: 250,
                    height: 250,
                    drawText: false,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: barcodeTextField),
        addHorizontalSpace(8),
        IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: _barcodeOverlay,
        ),
      ],
    );
    final priceDateRow = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: priceTextField),
        addHorizontalSpace(8),
        Expanded(
          child: GestureDetector(
            onTap: widget.isEditable ? _presentDatePicker : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _pickedDate ?? 'Select date',
                ),
                addHorizontalSpace(8),
                const Icon(Icons.calendar_month),
              ],
            ),
          ),
        ),
      ],
    );
    final imageWidget = ImageInput(
      onPickImage: (image) {
        _selectedImage = image;
      },
      image: _selectedImage,
      isEditable: widget.isEditable,
    );

    final barcodeRow = widget.isEditable ? barcodeIcon : barcodeTextField;

    if (isWideScreen) {
      return [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 1, child: imageWidget),
            addHorizontalSpace(10),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  nameTextField,
                  priceDateRow,
                  descriptionTextField,
                  barcodeRow,
                ],
              ),
            )
          ],
        )
      ];
    } else {
      return [
        nameTextField,
        priceDateRow,
        descriptionTextField,
        barcodeRow,
        addVerticalSpace(10),
        imageWidget,
        addVerticalSpace(10),
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
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: keyboardSpace),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildTextFields(
                      isWideScreen: isWideScreen || isLandscape),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
