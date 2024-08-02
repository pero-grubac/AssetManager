// ignore_for_file: constant_identifier_names

import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALS = [
  MapLocale("en", LocalData.EN),
  MapLocale("srb", LocalData.SRB),
];
mixin LocalData {
  static const String title = 'title';
  static const String body = 'body';

  static const Map<String, dynamic> EN = {
    title: 'AssetManager',
    body: 'Hi %a',
  };
  static const Map<String, dynamic> SRB = {
    title: 'Naslov',
    body: 'Tijelo %a',
  };
}
