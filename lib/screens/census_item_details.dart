import 'dart:async';

import 'package:asset_manager/models/census_item.dart';
import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/providers/asset_provider.dart';
import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/providers/util_provider.dart';
import 'package:asset_manager/providers/worker_provider.dart';
import 'package:asset_manager/screens/asset_details_screen.dart';
import 'package:asset_manager/screens/scan_barcode_screen.dart';
import 'package:asset_manager/widgets/util/centered_circular_loading.dart';
import 'package:asset_manager/widgets/util/helper_widgets.dart';
import 'package:asset_manager/widgets/worker/worker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/asset.dart';
import '../models/asset_location.dart';
import '../widgets/location/location_input.dart';
import '../widgets/util/build_text_field.dart';
import '../widgets/util/error_dialog.dart';

class CensusItemDetails extends ConsumerStatefulWidget {
  static const id = 'census_item_screen';

  const CensusItemDetails({
    super.key,
    this.censusItem,
    this.onSaveCensusItem,
    this.isEditable = true,
  });

  final CensusItem? censusItem;
  final Future<void> Function(CensusItem censusItem)? onSaveCensusItem;
  final bool isEditable;
  @override
  ConsumerState<CensusItemDetails> createState() => _CensusItemDetailsState();
}

class _CensusItemDetailsState extends ConsumerState<CensusItemDetails> {
  final _barcodeController = TextEditingController();

  AssetLocation? _oldAssetLocation;
  AssetLocation? _newAssetLocation;

  Worker? _oldWorker;
  Worker? _newWorker;

  Asset? _asset;
  bool _isLoading = true;

  void _initializeData() async {
    setIsLoading(true);
    if (widget.censusItem != null) {
      try {
        _oldAssetLocation = await ref
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

        if (mounted) {
          setState(() {
            _barcodeController.text = _asset?.barcode.toString() ?? '';
          });
        }
      } catch (e) {
        if (mounted) {
          ErrorDialog.show(context, AppLocalizations.of(context)!.loadingError);
        }
      }
    }
    if (mounted) {
      setIsLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData(); // Use a separate method to handle async loading
  }

  @override
  void dispose() {
    _barcodeController.dispose();

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
            label: AppLocalizations.of(context)!.barcode,
            isEditable: !widget.isEditable,
          ),
        ),
        addHorizontalSpace(8),
        if (widget.isEditable)
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
    if (!mounted) return;
    if (scanResult != null && scanResult.isNotEmpty && scanResult != '-1') {
      _barcodeController.text = scanResult;
      int? barcode = int.tryParse(_barcodeController.text);

      if (barcode != null) {
        _asset =
            await ref.read(assetProvider.notifier).findAssetByBarcode(barcode);
      } else {
        if (mounted) {
          ErrorDialog.show(context, AppLocalizations.of(context)!.barcodeNum);
        }
      }
    }
  }

  Future<void> _loadAsset() async {
    if (!mounted) return;

    if (_barcodeController.text.isEmpty) {
      if (mounted) {
        ErrorDialog.show(context, AppLocalizations.of(context)!.emptyBarcode);
      }
      return;
    }
    int? barcode = int.tryParse(_barcodeController.text.trim());
    if (barcode != null) {
      _asset =
          await ref.read(assetProvider.notifier).findAssetByBarcode(barcode);
    } else {
      if (mounted) {
        ErrorDialog.show(context, AppLocalizations.of(context)!.barcodeNum);
      }
      return;
    }

    if (_asset != null && mounted) {
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

  Widget _buildNewWorkerField() {
    return WorkerField(
      isEditable: widget.isEditable,
      initialWorker: _newWorker,
      onWorkerSelected: (worker) {
        _newWorker = worker;
      },
      textFieldLabel: AppLocalizations.of(context)!.newWorker,
      controllerTextEmpty: AppLocalizations.of(context)!.noNewWorker,
    );
  }

  Widget _buildOldWorkerField() {
    return WorkerField(
      isEditable: widget.isEditable,
      initialWorker: _oldWorker,
      onWorkerSelected: (worker) {
        _oldWorker = worker;
      },
      textFieldLabel: AppLocalizations.of(context)!.oldWorker,
      controllerTextEmpty: AppLocalizations.of(context)!.noOldWorker,
    );
  }

  Widget _buildLocationInput({
    required AssetLocation? location,
    required bool isEditable,
    required Function(AssetLocation?) onLocationChanged,
    required bool isLandscape,
  }) {
    return _isLoading
        ? const CenteredCircularLoading()
        : LocationInput(
            onSelectedLocation: onLocationChanged,
            assetLocation: location,
            isEditable: isEditable,
            isLandscape: isLandscape,
          );
  }

  List<Widget> _buildFields({required bool isWideScreen}) {
    return _isLoading
        ? [const CenteredCircularLoading()]
        : [
            _buildBarcodeField(),
            _buildOldWorkerField(),
            addVerticalSpace(10),
            _buildLocationInput(
              location: _oldAssetLocation,
              isEditable: widget.isEditable,
              onLocationChanged: (location) {
                setState(() {
                  _oldAssetLocation = location;
                });
              },
              isLandscape: isWideScreen,
            ),
            addVerticalSpace(10),
            _buildNewWorkerField(),
            addVerticalSpace(10),
            _buildLocationInput(
              location: _newAssetLocation,
              isEditable: widget.isEditable,
              onLocationChanged: (location) {
                setState(() {
                  _newAssetLocation = location;
                });
              },
              isLandscape: isWideScreen,
            ),
          ];
  }

  Future<void> _submitData() async {
    if (!mounted) return;

    int? barcode = int.tryParse(_barcodeController.text.trim());
    if (barcode == null) {
      if (mounted) {
        ErrorDialog.show(context, AppLocalizations.of(context)!.emptyBarcode);
      }
      return;
    }
    if (_oldWorker == null) {
      if (mounted) {
        ErrorDialog.show(context, AppLocalizations.of(context)!.noOldWorker);
      }
      return;
    }
    if (_oldAssetLocation == null) {
      if (mounted) {
        ErrorDialog.show(context, AppLocalizations.of(context)!.noOldLocation);
      }
      return;
    }
    _asset ??=
        await ref.read(assetProvider.notifier).findAssetByBarcode(barcode);
    _newWorker ??= _oldWorker;
    _newAssetLocation ??= _oldAssetLocation;
    try {
      CensusItem censusItem;
      String id = ref.read(censusListIdProvider.notifier).state;

      if (widget.censusItem == null) {
        censusItem = CensusItem(
          censusListId: id,
          assetId: _asset!.id,
          oldPersonId: _oldWorker!.id,
          newPersonId: _newWorker!.id,
          oldLocationId: _oldAssetLocation!.id,
          newLocationId: _newAssetLocation!.id,
        );
      } else {
        censusItem = CensusItem(
          id: widget.censusItem!.id,
          censusListId: id,
          assetId: _asset!.id,
          oldPersonId: _oldWorker!.id,
          newPersonId: _newWorker!.id,
          oldLocationId: _oldAssetLocation!.id,
          newLocationId: _newAssetLocation!.id,
        );
      }
      widget.onSaveCensusItem!(censusItem);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        if (e is ArgumentError) {
          ErrorDialog.show(context, e.message);
        } else {
          ErrorDialog.show(context, AppLocalizations.of(context)!.unknownError);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.censusItemDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitData,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: keyboardSpace),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _buildFields(isWideScreen: isWideScreen || isLandscape),
              ),
            ),
          );
        },
      ),
    );
  }
}
