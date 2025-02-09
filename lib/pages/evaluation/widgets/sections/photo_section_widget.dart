import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/helper/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';

class PhotoSectionWidget extends StatefulWidget {
  const PhotoSectionWidget({super.key, required this.evaluation, required this.source});
  final EvaluationModel evaluation;
  final EvaluationSource source;

  @override
  State<PhotoSectionWidget> createState() => _SignatureSectionWidgetState();
}

class _SignatureSectionWidgetState extends State<PhotoSectionWidget> {
  late final EvaluationController evaluationController;

  @override
  void initState() {
    super.initState();
    evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    const int maxPhotos = 6; // Número máximo de fotos
    const int crossAxisCount = 3; // Número de colunas no grid
    const double cellHeight = 110; // Altura de cada célula
    const double spacing = 8; // Espaçamento entre as células

    // Adiciona placeholders para fotos ainda não tiradas
    final List<String?> photoPaths = List.generate(
      maxPhotos,
      (index) => index < widget.evaluation.photoPaths.length ? widget.evaluation.photoPaths[index].path : null, // Fotos vazias
    );

    // Calcula o número de linhas necessárias
    final int rowCount = (maxPhotos / crossAxisCount).ceil();

    // Calcula a altura total necessária para o grid
    double totalHeight = (rowCount * cellHeight) + ((rowCount - 1) * spacing);
    if (totalHeight < 0) totalHeight = 0;

    return SizedBox(
      height: totalHeight,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // 3 colunas
          crossAxisSpacing: spacing, // Espaçamento horizontal
          mainAxisSpacing: spacing, // Espaçamento vertical
        ),
        itemCount: maxPhotos,
        physics: const NeverScrollableScrollPhysics(), // Impede rolagem
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
                          Text('Adicionar Foto',
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  )),
                        ],
                      ),
                    ),
            ),
            onTap: () async {
              if (!isPhotoTaken && widget.source != EvaluationSource.fromSaved) {
                // TODO: Adicionar lógica para capturar uma nova foto
              }
            },
            onLongPress: () async {
              if (isPhotoTaken && widget.source != EvaluationSource.fromSaved) {
                final bool isYes = await YesNoPicker.pick(
                      context: context,
                      question: 'Deseja excluir essa foto?',
                    ) ??
                    false;
                if (isYes) {
                  // TODO: Excluir a foto
                }
              }
            },
          );
        },
      ),
    );
  }
}
