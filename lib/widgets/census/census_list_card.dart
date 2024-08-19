import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/census_list.dart';

class CensusListCard extends StatelessWidget {
  const CensusListCard({super.key, required this.censusList});
  final CensusList censusList;

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 8), // Space between name and date
            RowIconWidget(
              icon: Icons.calendar_month,
              widget: Text(censusList.formatedDate),
            ),
          ],
        ),
        onTap: () {
          // TODO
        },
      ),
    );
  }
}
