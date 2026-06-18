import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/enums/image_types.dart';
import 'package:manager_mobile/services/image_service.dart';
import 'package:manager_mobile/core/locator.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({super.key});
  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  late final EvaluationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Locator.get<EvaluationController>();
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
      //TODO: ISSO PRECISA ESTAR NO EVALUATIONCONTROLLER E VIR DO LOCATOR. DEPOIS FAZER A MESMA COISA NA ASSINATURA
      final ImageService ims = ImageService();
      var tempPath = await ims.saveTemporaryFromPath(type: ImageTypes.photo, tempImagePath: photo.path);
      final file = File(tempPath);
      if (!mounted) return;
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
