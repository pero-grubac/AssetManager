import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  bool isCammera = true;
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
      label: const Text('Camera'),
      onPressed: () {
        _takePicture(ImageSource.camera);
        isCammera = true;
      },
    );
    Widget galleryWidget = TextButton.icon(
      icon: const Icon(Icons.photo_library),
      label: const Text('Gallery'),
      onPressed: () {
        _takePicture(ImageSource.gallery);
        isCammera = false;
      },
    );
    Widget buttonsRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cameraWidget,
        const SizedBox(
          width: 10,
        ),
        galleryWidget,
      ],
    );
    Widget content = buttonsRow;

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: () => _takePicture(
          isCammera ? ImageSource.camera : ImageSource.gallery,
        ),
        onDoubleTap: () {
          _cancelPicture();
          content = buttonsRow;
        },
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
        ),
      ),
      child: content,
    );
  }
}
