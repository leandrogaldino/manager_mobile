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
    // Número de imagens e colunas
    final int itemCount = widget.evaluation.photoPaths.length;
    const int crossAxisCount = 3; // Número de colunas no grid
    const double cellHeight = 120; // Altura de cada célula
    const double spacing = 8; // Espaçamento entre as células

    // Calcula o número de linhas necessárias
    final int rowCount = (itemCount / crossAxisCount).ceil();

    // Calcula a altura total necessária para o grid
    final double totalHeight = (rowCount * cellHeight) + ((rowCount - 1) * spacing);

    return SizedBox(
      height: totalHeight,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // 3 colunas
          crossAxisSpacing: spacing, // Espaçamento horizontal
          mainAxisSpacing: spacing, // Espaçamento vertical
        ),
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(), // Impede rolagem
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  child: Image.file(
                    File(widget.evaluation.photoPaths[index].path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            onLongPress: () async {
              if (widget.source == EvaluationSource.fromSaved) return;
              final bool isYes = await YesNoPicker.pick(context: context, question: 'Deseja excluir essa foto?') ?? false;
              if (isYes) {
                //Exclui a foto.
              }
            },
          );
        },
      ),
    );
  }
}
