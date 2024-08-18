import 'package:asset_manager/models/census_item.dart';
import 'package:asset_manager/widgets/util/centered_circular_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asset_location.dart';
import '../widgets/location/location_input.dart';
import '../widgets/util/build_text_field.dart';
import '../widgets/worker/worker_overlay.dart';

class CensusItemDetails extends ConsumerStatefulWidget {
  static const id = 'census_item_screen';

  const CensusItemDetails({
    super.key,
    this.censusItem,
    this.onSaveCensusItem,
  });
/*TODO
*  providers for location/worker
* implement functions
* */
  final CensusItem? censusItem;
  final Future<void> Function(CensusItem censusItem)? onSaveCensusItem;

  @override
  ConsumerState<CensusItemDetails> createState() => _CensusItemDetailsState();
}

class _CensusItemDetailsState extends ConsumerState<CensusItemDetails> {
  final _barcodeController = TextEditingController();
  final _workerController = TextEditingController();
  AssetLocation? _selectedAssetLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAssetDetails();
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _workerController.dispose();
    super.dispose();
  }

  Future<void> _initializeAssetDetails() async {
    setState(() => _isLoading = false);
  }

  Widget _buildBarcodeField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: BuildTextField(
            controller: _barcodeController,
            label: 'Barcode',
            isEditable: true,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () {
            // Add your barcode scanning logic here
          },
        ),
        IconButton(
          onPressed: () {
            // Additional barcode options
          },
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    );
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
        title: const Text('Asset Details'),
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
