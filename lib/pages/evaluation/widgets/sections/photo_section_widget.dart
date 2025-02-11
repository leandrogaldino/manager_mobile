import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
import 'dart:ui' as ui;

class PhotoSectionWidget extends StatefulWidget {
  const PhotoSectionWidget({super.key});

  @override
  State<PhotoSectionWidget> createState() => _SignatureSectionWidgetState();
}

class _SignatureSectionWidgetState extends State<PhotoSectionWidget> {
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    final int maxPhotos = _evaluationController.source != EvaluationSource.fromSaved ? 6 : _evaluationController.evaluation!.photoPaths.length; // Número máximo de fotos
    const int crossAxisCount = 3;
    const double spacing = 8;

    final double cellWidth = (MediaQuery.of(context).size.width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
    final double cellHeight = cellWidth * 1.1;
    final List<String?> photoPaths = List.generate(
      maxPhotos,
      (index) => index < _evaluationController.evaluation!.photoPaths.length ? _evaluationController.evaluation!.photoPaths[index].path : null,
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
                child: isPhotoTaken
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
                      ),
              ),
              onTap: () async {
                if (!isPhotoTaken && _evaluationController.source != EvaluationSource.fromSaved) {
                  final File? file = await Navigator.pushNamed<File?>(context, Routes.evaluationPhoto);

                  if (file != null) {
                    verificarTamanhoDoArquivo(file);

                    final bytes = await file.readAsBytes();
                    final codec = await ui.instantiateImageCodec(bytes);
                    final frame = await codec.getNextFrame();
                    final image = frame.image;

                    print('Largura: ${image.width} px');
                    print('Altura: ${image.height} px');

                    setState(() {
                      _evaluationController.evaluation!.photoPaths.add(EvaluationPhotoModel(id: 0, path: file.path));
                    });
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
                    setState(() {
                      _evaluationController.evaluation!.photoPaths.remove(_evaluationController.evaluation!.photoPaths[index]);
                    });
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }

  void verificarTamanhoDoArquivo(File file) async {
    int tamanhoEmBytes = await file.length();
    double tamanhoEmKB = tamanhoEmBytes / 1024;
    double tamanhoEmMB = tamanhoEmKB / 1024;
    log('Tamanho do arquivo: ${tamanhoEmMB.toStringAsFixed(2)} MB');
  }
}
