import 'dart:io';

import 'package:asset_manager/models/asset.dart';
import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/providers/worker_provider.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/screens/selection_screen.dart';
import 'package:asset_manager/widgets/image/image_input.dart';
import 'package:asset_manager/widgets/location/location_input.dart';
import 'package:asset_manager/widgets/worker/worker_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/worker.dart';
import '../widgets/util/build_text_field.dart';
import '../widgets/util/error_dialog.dart';

class AssetDetailsScreen extends ConsumerStatefulWidget {
  const AssetDetailsScreen({
    super.key,
    this.onSaveAsset,
    this.asset,
    this.isEditable = true,
  });
  final Asset? asset;
  final Future<void> Function(
      Asset asset, AssetLocation location, Worker worker)? onSaveAsset;
  final bool isEditable;

  @override
  ConsumerState<AssetDetailsScreen> createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends ConsumerState<AssetDetailsScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();
  final _workerController = TextEditingController();

  File? _selectedImage;
  AssetLocation? _selectedAssetLocation;
  Worker? _selectedWorker;
  bool _isLoading = true;
  DateTime? _selectedDate;
  String? _pickedDate;
  @override
  void initState() {
    super.initState();
    _initializeAssetDetails();
  }

  Future<void> _initializeAssetDetails() async {
    if (widget.asset != null) {
      // Editing an existing asset
      _nameController.text = widget.asset!.name;
      _descriptionController.text = widget.asset!.description;
      _barcodeController.text = widget.asset!.barcode.toString();
      _priceController.text = widget.asset!.price.toString();
      _selectedImage = widget.asset?.image;
      _selectedDate = widget.asset?.creationDate;
      _pickedDate = widget.asset?.formatedDate;
      // Attempt to retrieve the location by its ID asynchronously
      _selectedAssetLocation = await ref
          .read(locationProvider.notifier)
          .findLocationById(widget.asset!.assignedLocationId);
      // wind worker by id and assign  it to _workerController
      _selectedWorker = await ref
          .read(workerProvider.notifier)
          .findWorkerById(widget.asset!.assignedPersonId);
    }
    setState(() {
      _isLoading = false;
    });
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
    if (_selectedAssetLocation == null) {
      ErrorDialog.show(context, 'Location  can not be empty');
      return;
    }
    if (_selectedDate == null) {
      ErrorDialog.show(context, 'Date  can not be empty');
      return;
    }
    if (_selectedWorker == null) {
      ErrorDialog.show(context, 'Worker  can not be empty');
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
          assignedPersonId: _selectedWorker!.id,
          assignedLocationId: _selectedAssetLocation!.id,
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
          assignedPersonId: _selectedWorker!.id,
          assignedLocationId: _selectedAssetLocation!.id,
          image: _selectedImage!,
        );
      }
      widget.onSaveAsset!(asset, _selectedAssetLocation!, _selectedWorker!);
      Navigator.pop(context);
    } catch (e) {
      if (e is ArgumentError) {
        ErrorDialog.show(context, e.message);
      } else {
        ErrorDialog.show(context, 'An unknown error occurred');
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

  void _existingWorkers() async {
    setState(() {
      _workerController.text = '';
    });
    final selectedWorker = await Navigator.push<Worker>(
      context,
      MaterialPageRoute(
          builder: (ctx) => SelectionScreen<Worker>(
                provider: workerProvider,
                onConfirmSelection: (selectedItem) {},
                cardBuilder:
                    (Worker item, bool isSelected, void Function() onTap) {
                  return WorkerCard(
                    worker: item,
                    onTap: onTap,
                    isSelected: isSelected,
                  );
                },
                title: 'Select worker',
              )),
    );
    if (selectedWorker != null) {
      setState(() {
        _workerController.text = selectedWorker.fullName;
        _selectedWorker = selectedWorker;
      });
    } else {
      return;
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
      crossAxisAlignment: CrossAxisAlignment.end,
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
    final priceDateRow = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: priceTextField),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: widget.isEditable ? _presentDatePicker : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _pickedDate ?? 'Select date',
                ),
                const SizedBox(width: 8),
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
    final workerWidget = BuildTextField(
      controller: _workerController,
      label: 'Worker',
      isEditable: true,
    );
    final workerRow = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: workerWidget),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            // TODO add new
          },
          icon: const Icon(Icons.add),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _existingWorkers,
          icon: const Icon(Icons.supervised_user_circle),
        ),
      ],
    );
    final barcodeRow = widget.isEditable ? barcodeIcon : barcodeTextField;
    final Widget locationWidget;
    if (_isLoading) {
      locationWidget = const Center(child: CircularProgressIndicator());
    } else {
      locationWidget = LocationInput(
        onSelectedLocation: (assetLocation) {
          _selectedAssetLocation = assetLocation;
        },
        assetLocation: _selectedAssetLocation,
        isEditable: widget.isEditable,
      );
    }
    if (isWideScreen) {
      // TODO
      return [];
    } else {
      return [
        nameTextField,
        priceDateRow,
        descriptionTextField,
        barcodeRow,
        workerRow,
        const SizedBox(
          height: 10,
        ),
        imageWidget,
        const SizedBox(
          height: 10,
        ),
        locationWidget,
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
