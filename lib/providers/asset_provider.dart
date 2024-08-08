import 'package:asset_manager/models/asset.dart';
import 'package:asset_manager/providers/search_provider.dart';
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
            imagePath: 'imagePath',
          ),
          Asset(
            name: '1ime',
            description: '1description',
            barcode: 1123456,
            price: 1123456,
            creationDate: DateTime.now(),
            assignedPersonId: '1assignedPersonId',
            assignedLocationId: '1assignedLocationId',
            imagePath: '1imagePath',
          )
        ]);
  void addAsset(Asset asset) {
    state = [asset, ...state];
  }

  void searchAssets(String query) {
    List<Asset> results;
    if (query.isEmpty) {
      results = state;
    } else {
      final queryLower = query.toLowerCase();
      double? queryAsDouble = double.tryParse(query);
      results = state.where((asset) {
        final assetName = asset.name.toLowerCase();
        final assetPrice = asset.price;
        bool matchesName = assetName.contains(queryLower);
        bool matchesPrice =
            queryAsDouble != null && assetPrice == queryAsDouble;
        return matchesPrice || matchesName;
      }).toList();
    }
    state = results;
  }

  void removeAsset(Asset asset) {
    state = state.where((a) => a.id != asset.id).toList();
  }

  int indexOfAsset(Asset asset) {
    return state.indexOf(asset);
  }

  void insetAsset(Asset asset, int index) {
    final newList = [...state];
    newList.insert(index, asset);
    state = newList;
  }

  void updateAsset(Asset updatedAsset) {
    final index = state.indexWhere((asset) => asset.id == updatedAsset.id);
    List<Asset> temp = state;
    temp[index] = updatedAsset;
    state = [...temp];
  }
}

final assetProvider = StateNotifierProvider<AssetNotifier, List<Asset>>(
  (ref) => AssetNotifier(),
);

final filteredAssetsProvider = Provider<List<Asset>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  double? queryAsDouble = double.tryParse(query);

  final assets = ref.watch(assetProvider);
  if (query.isEmpty) return assets;
  return assets.where((asset) {
    final assetName = asset.name.toLowerCase();
    final assetPrice = asset.price;
    bool matchesName = assetName.contains(query);
    bool matchesPrice = queryAsDouble != null && assetPrice == queryAsDouble;
    return matchesPrice || matchesName;
  }).toList();
});
