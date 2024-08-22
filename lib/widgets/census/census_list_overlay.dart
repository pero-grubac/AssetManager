import 'package:asset_manager/widgets/util/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/census_list.dart';
import '../util/build_text_field.dart';
import '../util/error_dialog.dart';

class CensusListOverlay extends StatefulWidget {
  const CensusListOverlay({super.key, this.censusList, this.onSave});
  final CensusList? censusList;
  final void Function(CensusList censusList)? onSave;

  @override
  State<CensusListOverlay> createState() => _CensusListOverlayState();
}

class _CensusListOverlayState extends State<CensusListOverlay> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  String? _pickedDate;

  @override
  void initState() {
    super.initState();
    if (widget.censusList != null) {
      _nameController.text = widget.censusList!.name;
      _selectedDate = widget.censusList!.creationDate;
      _pickedDate = widget.censusList!.formatedDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _presentDatePicker() {
    final now = DateTime.now();
    final firstDate = DateTime(1900);
    final lastDate = now;
    showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: _selectedDate ?? now,
    ).then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        _selectedDate = pickedDate;
        _pickedDate = DateFormat('dd.MM.yyyy').format(_selectedDate!);
      });
    });
  }

  List<Widget> _buildTextFields() {
    final nameTextField = BuildTextField(
      controller: _nameController,
      label: AppLocalizations.of(context)!.name,
      isEditable: false, // Allow editing
    );

    final dateField = GestureDetector(
      onTap: _presentDatePicker,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _pickedDate ?? AppLocalizations.of(context)!.selectDate,
          ),
          addHorizontalSpace(8),
          const Icon(Icons.calendar_month),
        ],
      ),
    );

    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: nameTextField),
          addHorizontalSpace(16),
          Flexible(child: dateField),
        ],
      ),
      addVerticalSpace(16),
      Row(
        children: [
          if (widget.onSave == null) const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          if (widget.onSave != null) const Spacer(),
          if (widget.onSave != null)
            ElevatedButton(
              onPressed: _submitData,
              child: Text(AppLocalizations.of(context)!.save),
            ),
        ],
      ),
    ];
  }

  void _submitData() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      // TODO translate empty name
      ErrorDialog.show(context,
          AppLocalizations.of(context)!.emptyPrice); // Handle empty name error
      return;
    }
    if (_selectedDate == null) {
      ErrorDialog.show(context, AppLocalizations.of(context)!.emptyDate);
      return;
    }

    try {
      CensusList censusList;
      if (widget.censusList == null) {
        censusList = CensusList(
          name: name,
          creationDate: _selectedDate!,
        );
      } else {
        censusList = CensusList(
          id: widget.censusList!.id,
          name: name,
          creationDate: _selectedDate!,
        );
      }

      widget.onSave?.call(censusList);
      Navigator.pop(context);
    } catch (e) {
      if (e is ArgumentError) {
        ErrorDialog.show(context, e.message);
      } else {
        ErrorDialog.show(context, AppLocalizations.of(context)!.unknownError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Material(
        child: SizedBox(
          width: constraints.maxWidth * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addVerticalSpace(24),
                ..._buildTextFields(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
