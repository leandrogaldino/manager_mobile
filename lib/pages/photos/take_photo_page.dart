import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({super.key});

  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  @override
  void initState() {
    super.initState();

    openCamera();
  }

  Future<void> openCamera() async {
    try {
      final picker = ImagePicker();

      final photo = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 95,
      );

      if (!mounted) {
        return;
      }

      if (photo == null) {
        Navigator.pop(context);
        return;
      }

      final file = File(photo.path);

      Navigator.pop(context, file);
    } catch (e) {
      debugPrint('Erro ao abrir câmera: $e');

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
