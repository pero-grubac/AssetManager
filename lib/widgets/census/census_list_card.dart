import 'package:asset_manager/providers/util_provider.dart';
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
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              RowIconWidget(
                icon: Icons.list,
                widget: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Text(
                    censusList.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              RowIconWidget(
                icon: Icons.calendar_month,
                widget: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Text(
                    censusList.formatedDate,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          ref.read(censusListIdProvider.notifier).state = censusList.id;
          Navigator.pushNamed(context, CensusListItemsScreen.id);
        },
      ),
    );
  }
}
