import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/census_list.dart';
import '../util/build_text_field.dart';

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
    if (widget.censusList != null) {
      _nameController.text = widget.censusList!.name;
      _selectedDate = widget.censusList!.creationDate;
      _pickedDate = widget.censusList!.formatedDate;
    }
    super.initState();
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
      initialDate: now,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _pickedDate = DateFormat('dd.MM.yyyy').format(_selectedDate!);
      });
    });
  }

  List<Widget> _buildTextFields({required bool isWideScreen}) {
    final nameTextField = BuildTextField(
      controller: _nameController,
      label: 'Name',
      isEditable: false,
    );
    final dateField = GestureDetector(
      onTap: _presentDatePicker,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _pickedDate ?? 'Select date',
          ),
          const SizedBox(width: 8),
          const Icon(Icons.calendar_month),
        ],
      ),
    );
    if (isWideScreen) {
      // TODO
      return [];
    } else {
      return [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: nameTextField),
            const SizedBox(width: 16),
            Expanded(child: dateField)
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (widget.onSave == null) const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            if (widget.onSave != null) const Spacer(),
            if (widget.onSave != null)
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save'),
              ),
          ],
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final isWideScreen = constraints.maxWidth > 600;

      return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildTextFields(isWideScreen: isWideScreen),
            ),
          ),
        ),
      );
    });
  }
}
