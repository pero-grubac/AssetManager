import 'package:asset_manager/models/category/category.dart';
import 'package:asset_manager/screens/asset_screen.dart';
import 'package:asset_manager/screens/census_list_screen.dart';
import 'package:asset_manager/screens/location_screen.dart';
import 'package:asset_manager/screens/workers_screen.dart';
import 'package:flutter/material.dart';

const categories = [
  Category(
    id: LocationScreen.id,
    title: 'Locations',
    icon: Icon(Icons.location_city),
  ),
  Category(
    id: WorkersScreen.id,
    title: 'Workers',
    icon: Icon(Icons.person_2),
  ),
  Category(
    id: AssetScreen.id,
    title: 'Assets',
    icon: Icon(Icons.business_center),
  ),
  Category(
    id: CensusListScreen.id,
    title: 'Census list',
    icon: Icon(Icons.checklist),
  ),
];
