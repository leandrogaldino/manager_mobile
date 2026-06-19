import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/enums/photo_state.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/util/internet_connection.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';

class PhotoSectionWidget extends StatefulWidget {
  const PhotoSectionWidget({
    super.key,
    required this.evaluationController,
  });

  final EvaluationController evaluationController;

  @override
  State<PhotoSectionWidget> createState() => _PhotoSectionWidgetState();
}

class _PhotoSectionWidgetState extends State<PhotoSectionWidget> {
  final Set<String> _downloadingPhotos = {};
  @override
  Widget build(BuildContext context) {
    final EvaluationController controller = widget.evaluationController;
    final int maxPhotos = controller.source != SourceTypes.fromSavedWithSign ? 6 : controller.evaluation!.photos.length;
    const int crossAxisCount = 3;
    const double spacing = 8;
    final double cellWidth = (MediaQuery.of(context).size.width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
    final double cellHeight = cellWidth * 1.5;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: maxPhotos,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: cellWidth / cellHeight,
        ),
        itemBuilder: (context, index) {
          final photo = index < controller.evaluation!.photos.length ? controller.evaluation!.photos[index] : null;
          final tempPath = photo?.tempPath;
          final localPath = photo?.localPath;
          final cloudPath = photo?.cloudPath;
          final bool isPhotoTaken = tempPath != null || localPath != null || cloudPath != null;
          final state = PhotoState.getPhotoState(tempPath, localPath, cloudPath, _downloadingPhotos);
          return GestureDetector(
            onTap: () async {
              switch (state) {
                case PhotoState.downloading:
                  return;
                case PhotoState.cloud:
                  _downloadPhoto(index, cloudPath!);
                case PhotoState.temp || PhotoState.local:
                  _viewPhoto(index);
                case PhotoState.empty:
                  _takePhoto();
              }
            },
            onLongPress: () async {
              if (isPhotoTaken && controller.source != SourceTypes.fromSavedWithSign) {
                final bool isYes = await YesNoPicker.pick(
                      context: context,
                      question: 'Deseja excluir essa foto?',
                    ) ??
                    false;
                if (isYes) {
                  controller.removePhoto(controller.evaluation!.photos[index]);
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              child: _buildPhotoContent(state: state, tempPath: tempPath, localPath: localPath),
            ),
          );
        },
      ),
    );
  }

  Future<void> _takePhoto() async {
    final controller = widget.evaluationController;
    final File? file = await Navigator.pushNamed<File?>(context, Routes.takePhoto);
    if (!mounted) return;
    if (file != null) {
      controller.addPhoto(
        EvaluationPhotoModel(
          tempPath: file.path,
          localPath: null,
          cloudPath: null,
        ),
      );
    }
  }

  Widget _buildPhotoContent({required PhotoState state, String? tempPath, String? localPath}) {
    switch (state) {
      case PhotoState.downloading:
        return _downloadingWidget();

      case PhotoState.temp:
        return _viewPhotoWidget(tempPath!);

      case PhotoState.local:
        return _viewPhotoWidget(localPath!);

      case PhotoState.cloud:
        return _downloadPhotoWidget();

      case PhotoState.empty:
        return _emptyPhotoWidget();
    }
  }

  Future<void> _viewPhoto(int index) async {
    final controller = widget.evaluationController;
    controller.setSelectedPhotoIndex(index);
    await Navigator.pushNamed(context, Routes.viewPhoto);
    if (!mounted) return;
    controller.setSelectedPhotoIndex(null);
  }

  Future<void> _downloadPhoto(int index, String cloudPath) async {
    final hasInternet = await InternetConnectionStream.hasInternetNow();
    final controller = widget.evaluationController;
    if (!hasInternet) {
      if (!mounted) return;
      Message.showInfoSnackbar(context: context, message: 'Sem conexão com a internet');
      return;
    }

    setState(() {
      _downloadingPhotos.add(cloudPath);
    });

    try {
      await controller.downloadPhoto(index: index);
    } finally {
      if (mounted) {
        setState(() {
          _downloadingPhotos.remove(cloudPath);
        });
      }
    }
  }

  Icon _downloadPhotoWidget() {
    return Icon(
      Icons.cloud_download,
      color: Theme.of(context).colorScheme.primary,
      size: 38,
    );
  }

  ClipRRect _viewPhotoWidget(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.low,
        cacheWidth: 600,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) {
          return const Center(
            child: Icon(Icons.broken_image),
          );
        },
      ),
    );
  }

  Center _downloadingWidget() {
    return const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _emptyPhotoWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Adicionar Foto',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
