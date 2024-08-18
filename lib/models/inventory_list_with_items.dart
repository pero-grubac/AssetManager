import 'census_item.dart';
import 'census_list.dart';

class InventoryListWithItems {
  final CensusList inventoryList;
  final List<CensusItem> items;

  InventoryListWithItems({
    required this.inventoryList,
    required this.items,
  });
}
