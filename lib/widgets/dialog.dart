import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//! ويدجت يعاد استخدامها -- dialog  -> بسنت سعيد
// ignore: must_be_immutable
class DialogBox extends StatefulWidget {
  DialogBox({super.key, required this.image, required this.onImagePicked});

  File? image;
  Function(File) onImagePicked;

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final ImagePicker imagePicker = ImagePicker();

  Future CameraPicker() async {
    var cameraImage = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (cameraImage != null && mounted) {
        widget.onImagePicked(
            File(cameraImage.path)); // Call the callback to update the parent
      } else {}
    });
  }

  Future GalleryPicker() async {
    var galleryImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (galleryImage != null && mounted) {
        widget.onImagePicked(
            File(galleryImage.path)); // Call the callback to update the parent
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Upload image"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: GestureDetector(
                onTap: () async {
                  await CameraPicker();
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text("Camera"),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () async {
                await GalleryPicker();
                Navigator.pop(context);
              },
              child: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library_rounded,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 10),
                    Text("Gallery"),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
