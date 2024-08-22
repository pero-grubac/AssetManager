import 'package:asset_manager/providers/util_provider.dart';
import 'package:asset_manager/widgets/util/helper_widgets.dart';
import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/census_list.dart';
import '../../screens/census_list_items_screen.dart';

class CensusListCard extends ConsumerWidget {
  const CensusListCard({super.key, required this.censusList});
  final CensusList censusList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RowIconWidget(
                icon: Icons.list,
                widget: Text(
                  censusList.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
            addHorizontalSpace(8), // Space between name and date
            RowIconWidget(
              icon: Icons.calendar_month,
              widget: Text(censusList.formatedDate),
            ),
          ],
        ),
        onTap: () {
          ref.read(censusListIdProvider.notifier).state = censusList.id;
          Navigator.pushNamed(context, CensusListItemsScreen.id);
        },
      ),
    );
  }
}
