import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
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
          final localPath = photo?.localPath;
          final cloudPath = photo?.cloudPath;
          final bool isPhotoTaken = localPath != null || cloudPath != null;
          return GestureDetector(
            onTap: () async {
              if (cloudPath != null && localPath == null) {
                if (_downloadingPhotos.contains(cloudPath)) {
                  return;
                }

                final hasInternet = await InternetConnectionStream.hasInternetNow();

                if (!hasInternet) {
                  if (!context.mounted) return;

                  Message.showInfoSnackbar(
                    context: context,
                    message: 'Sem conexão com a internet',
                  );

                  return;
                }

                setState(() {
                  _downloadingPhotos.add(cloudPath);
                });

                try {
                  await controller.downloadPhoto(
                    index: index,
                    cloudPath: cloudPath,
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      _downloadingPhotos.remove(cloudPath);
                    });
                  }
                }
              } else if (localPath != null) {
                controller.setSelectedPhotoIndex(index);

                await Navigator.pushNamed(
                  context,
                  Routes.viewPhoto,
                );
                if (!mounted) return;
                controller.setSelectedPhotoIndex(null);
              } else {
                final File? file = await Navigator.pushNamed<File?>(
                  context,
                  Routes.takePhoto,
                );
                if (!mounted) return;
                if (file != null) {
                  controller.addPhoto(
                    EvaluationImageModel(
                      localPath: file.path,
                    ),
                  );
                }
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
              child: _downloadingPhotos.contains(cloudPath)
                  ? const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : isPhotoTaken
                      ? localPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(localPath),
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
                            )
                          : Icon(
                              Icons.cloud_download,
                              color: Theme.of(context).colorScheme.primary,
                              size: 38,
                            )
                      : Center(
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
                        ),
            ),
          );
        },
      ),
    );
  }
}
