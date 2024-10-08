import 'dart:io';

import 'package:asset_manager/widgets/util/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onPickImage,
    this.image,
    this.isEditable = true,
  });
  final void Function(File image) onPickImage;
  final File? image;
  final bool isEditable;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  bool isCammera = true;
  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      _selectedImage = widget.image;
    }
  }

  void _takePicture(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onPickImage(_selectedImage!);
  }

  void _cancelPicture() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget cameraWidget = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: Text(AppLocalizations.of(context)!.camera),
      onPressed: () {
        _takePicture(ImageSource.camera);
        isCammera = true;
      },
    );
    Widget galleryWidget = TextButton.icon(
      icon: const Icon(Icons.photo_library),
      label: Text(AppLocalizations.of(context)!.gallery),
      onPressed: () {
        _takePicture(ImageSource.gallery);
        isCammera = false;
      },
    );
    Widget buttonsRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cameraWidget,
        addHorizontalSpace(10),
        galleryWidget,
      ],
    );
    Widget content = buttonsRow;

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: () => widget.isEditable
            ? _takePicture(
                isCammera ? ImageSource.camera : ImageSource.gallery,
              )
            : null,
        onDoubleTap: () {
          if (widget.isEditable) {
            _cancelPicture();
            content = buttonsRow;
          }
        },
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: content,
        ),
        if (_selectedImage != null && widget.isEditable) addVerticalSpace(10),
        if (_selectedImage != null && widget.isEditable) buttonsRow,
      ],
    );
  }
}
