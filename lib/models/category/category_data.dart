import 'package:asset_manager/models/category/category.dart';
import 'package:asset_manager/screens/asset_screen.dart';
import 'package:asset_manager/screens/census_list_screen.dart';
import 'package:asset_manager/screens/location_screen.dart';
import 'package:asset_manager/screens/workers_screen.dart';

const categories = [
  Category(
    id: LocationScreen.id,
    title: 'Locations',
  ),
  Category(
    id: WorkersScreen.id,
    title: 'Workers',
  ),
  Category(
    id: AssetScreen.id,
    title: 'Assets',
  ),
  Category(
    id: CensusListScreen.id,
    title: 'Census list',
  ),
];
