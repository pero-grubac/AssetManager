import 'package:asset_manager/models/asset.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetNotifier extends StateNotifier<List<Asset>> {
  AssetNotifier()
      : super([
          Asset(
              name: 'ime',
              description: 'description',
              barcode: 123456,
              price: 123456,
              creationDate: DateTime.now(),
              assignedPersonId: 'assignedPersonId',
              assignedLocationId: 'assignedLocationId',
              imagePath: 'imagePath')
        ]);
  void addAsset(Asset asset) {
    state = [asset, ...state];
  }
}

final assetProvider = StateNotifierProvider<AssetNotifier, List<Asset>>(
  (ref) => AssetNotifier(),
);
