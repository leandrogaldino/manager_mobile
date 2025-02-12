import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';

//TODO: Mudar o estado pela controller.
class PhotoSectionWidget extends StatefulWidget {
  const PhotoSectionWidget({super.key});

  @override
  State<PhotoSectionWidget> createState() => _PhotoSectionWidgetState();
}

class _PhotoSectionWidgetState extends State<PhotoSectionWidget> {
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    final int maxPhotos = _evaluationController.source != EvaluationSource.fromSaved ? 6 : _evaluationController.evaluation!.photos.length; // Número máximo de fotos
    const int crossAxisCount = 3;
    const double spacing = 8;

    final double cellWidth = (MediaQuery.of(context).size.width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
    final double cellHeight = cellWidth * 1.1;
    final List<String?> photoPaths = List.generate(
      maxPhotos,
      (index) => index < _evaluationController.evaluation!.photos.length ? _evaluationController.evaluation!.photos[index].path : null,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: cellWidth / cellHeight,
          ),
          itemCount: maxPhotos,
          itemBuilder: (context, index) {
            final String? photoPath = photoPaths[index];
            final bool isPhotoTaken = photoPath != null;

            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: ListenableBuilder(
                    listenable: _evaluationController,
                    builder: (context, child) {
                      return isPhotoTaken
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(photoPath),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Theme.of(context).colorScheme.primary.withAlpha(100),
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
                    }),
              ),
              onTap: () async {
                if (!isPhotoTaken && _evaluationController.source != EvaluationSource.fromSaved) {
                  final File? file = await Navigator.pushNamed<File?>(context, Routes.evaluationPhoto);
                  if (file != null) {
                    _evaluationController.addPhoto(EvaluationPhotoModel(id: 0, path: file.path));
                    await _evaluationController.updateImagesBytes();
                  }
                }
              },
              onLongPress: () async {
                if (isPhotoTaken && _evaluationController.source != EvaluationSource.fromSaved) {
                  final bool isYes = await YesNoPicker.pick(
                        context: context,
                        question: 'Deseja excluir essa foto?',
                      ) ??
                      false;
                  if (isYes) {
                    _evaluationController.removePhoto(_evaluationController.evaluation!.photos[index]);
                    await _evaluationController.updateImagesBytes();
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
