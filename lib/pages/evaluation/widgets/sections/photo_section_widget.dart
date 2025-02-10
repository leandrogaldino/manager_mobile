import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/helper/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
import 'dart:ui' as ui;

//TODO: alterar para o controller
//TODO: Fazer EvaluationPhotoViewPage (Entra ao clicar em uma foto ja tirada)
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
    final int maxPhotos = widget.source != EvaluationSource.fromSaved ? 6 : widget.evaluation.photoPaths.length; // Número máximo de fotos
    const int crossAxisCount = 3;
    const double cellHeight = 110;
    const double spacing = 8;

    final List<String?> photoPaths = List.generate(
      maxPhotos,
      (index) => index < widget.evaluation.photoPaths.length ? widget.evaluation.photoPaths[index].path : null, // Fotos vazias
    );
    final int rowCount = (maxPhotos / crossAxisCount).ceil();
    double totalHeight = (rowCount * cellHeight) + ((rowCount - 1) * spacing);
    if (totalHeight < 0) totalHeight = 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: totalHeight,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: maxPhotos,
          physics: const NeverScrollableScrollPhysics(),
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
                  // Exibe a tela de captura de foto
                  final File? file = await Navigator.pushNamed<File?>(context, Routes.evaluationPhoto);

                  // Verifique se uma foto foi tirada e faça o que for necessário
                  if (file != null) {
                    // Aqui você pode salvar o arquivo da foto tirada

                    verificarTamanhoDoArquivo(file);

                    final bytes = await file.readAsBytes(); // Lê os bytes do arquivo
                    final codec = await ui.instantiateImageCodec(bytes); // Cria um codec da imagem
                    final frame = await codec.getNextFrame(); // Obtém o primeiro frame da imagem
                    final image = frame.image;

                    print('Largura: ${image.width} px'); //1080
                    print('Altura: ${image.height} px');

                    setState(() {
                      // Adicione a foto ao modelo ou lista de fotos
                      widget.evaluation.photoPaths.add(EvaluationPhotoModel(id: 0, path: file.path));
                    });
                  }
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
                    setState(() {
                      widget.evaluation.photoPaths.remove(widget.evaluation.photoPaths[index]);
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

//TODO: Depois que fizer o photoviewpage, verificar se metade do tamanho atual esta bom.
  void verificarTamanhoDoArquivo(File file) async {
    int tamanhoEmBytes = await file.length();
    double tamanhoEmKB = tamanhoEmBytes / 1024;
    double tamanhoEmMB = tamanhoEmKB / 1024;
    log('Tamanho do arquivo: ${tamanhoEmMB.toStringAsFixed(2)} MB');
  }
}
