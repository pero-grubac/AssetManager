import 'inventory_item.dart';
import 'inventory_list.dart';

class InventoryListWithItems {
  final InventoryList inventoryList;
  final List<InventoryItem> items;

  InventoryListWithItems({
    required this.inventoryList,
    required this.items,
  });
}
