import 'dart:async';

import 'package:asset_manager/models/census_item.dart';
import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/providers/asset_provider.dart';
import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/providers/worker_provider.dart';
import 'package:asset_manager/screens/asset_details_screen.dart';
import 'package:asset_manager/screens/scan_barcode_screen.dart';
import 'package:asset_manager/widgets/util/centered_circular_loading.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asset.dart';
import '../models/asset_location.dart';
import '../widgets/location/location_input.dart';
import '../widgets/util/build_text_field.dart';
import '../widgets/util/error_dialog.dart';
import '../widgets/worker/worker_overlay.dart';

class CensusItemDetails extends ConsumerStatefulWidget {
  static const id = 'census_item_screen';

  const CensusItemDetails({
    super.key,
    this.censusItem,
    this.onSaveCensusItem,
    this.isEditable = true,
  });
/*TODO
*  providers for location/worker
* implement functions
* */
  final CensusItem? censusItem;
  final Future<void> Function(CensusItem censusItem)? onSaveCensusItem;
  final bool isEditable;
  @override
  ConsumerState<CensusItemDetails> createState() => _CensusItemDetailsState();
}

class _CensusItemDetailsState extends ConsumerState<CensusItemDetails> {
  final _barcodeController = TextEditingController();
  final _workerController = TextEditingController();
  AssetLocation? _selectedAssetLocation;
  AssetLocation? _currentAssetLocation;
  AssetLocation? _newAssetLocation;

  Worker? _oldWorker;
  Worker? _newWorker;

  Asset? _asset;
  bool _isLoading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (widget.censusItem != null) {
      _currentAssetLocation = await ref
          .read(locationProvider.notifier)
          .findLocationById(widget.censusItem!.oldLocationId);
      _newAssetLocation = await ref
          .read(locationProvider.notifier)
          .findLocationById(widget.censusItem!.newLocationId);
      _oldWorker = await ref
          .read(workerProvider.notifier)
          .findWorkerById(widget.censusItem!.oldPersonId);
      _newWorker = await ref
          .read(workerProvider.notifier)
          .findWorkerById(widget.censusItem!.newPersonId);
      _asset = await ref
          .read(assetProvider.notifier)
          .findAssetById(widget.censusItem!.assetId);
      _barcodeController.text = _asset!.barcode.toString();
    }
    setIsLoading(false);
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _workerController.dispose();
    super.dispose();
  }

  void setIsLoading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  Widget _buildBarcodeField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: BuildTextField(
            controller: _barcodeController,
            label: 'Barcode',
            isEditable: !widget.isEditable,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: _scanBarcode,
        ),
        IconButton(
          onPressed: _loadAsset,
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    );
  }

  Future<void> _scanBarcode() async {
    final scanResult = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanBarcodeScreen(),
      ),
    );
    if (scanResult != null && scanResult.isNotEmpty && scanResult != '-1') {
      _barcodeController.text = scanResult;
    }
  }

  Future<void> _loadAsset() async {
    if (_barcodeController.text.isEmpty) {
      ErrorDialog.show(context, 'Barcode  can not be empty');
    } else {
      int? barcode = int.tryParse(_barcodeController.text.trim());
      if (barcode != null) {
        _asset =
            await ref.read(assetProvider.notifier).findAssetByBarcode(barcode);
      } else {
        ErrorDialog.show(context, 'Barcode is a number');
      }
    }
    if (_asset != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => AssetDetailsScreen(
            asset: _asset,
            isEditable: false,
          ),
        ),
      );
    }
  }

  Widget _buildWorkerField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: BuildTextField(
            controller: _workerController,
            label: 'Worker',
            isEditable: true,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            _showWorkerOverlay();
          },
          icon: const Icon(Icons.add),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            // Add your worker selection logic here
          },
          icon: const Icon(Icons.supervised_user_circle),
        ),
      ],
    );
  }

  Widget _buildLocationInput({required bool isEditable}) {
    return _isLoading
        ? const CenteredCircularLoading()
        : LocationInput(
            onSelectedLocation: (assetLocation) {
              _selectedAssetLocation = assetLocation;
            },
            assetLocation: _selectedAssetLocation,
            isEditable: isEditable,
          );
  }

  void _showWorkerOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => WorkerOverlay(
        onSaveWorker: (worker) {
          // Handle worker save logic
        },
      ),
    );
  }

  List<Widget> _buildFields({required bool isWideScreen}) {
    return [
      _buildBarcodeField(),
      BuildTextField(
        controller: _workerController,
        label: 'Current worker',
        isEditable: true,
      ),
      const SizedBox(height: 10),
      _buildLocationInput(isEditable: true),
      const SizedBox(height: 10),
      _buildWorkerField(),
      const SizedBox(height: 10),
      _buildLocationInput(isEditable: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Census Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Handle save logic here
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: keyboardSpace),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildFields(isWideScreen: isWideScreen),
              ),
            ),
          );
        },
      ),
    );
  }
}
