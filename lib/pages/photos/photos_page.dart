import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  late final EvaluationController _evaluationController;
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
    _pageController = PageController(initialPage: _evaluationController.selectedPhotoIndex!);
    _currentIndex = _evaluationController.selectedPhotoIndex!;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var photos = _evaluationController.evaluation!.photos;
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Fotos'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
          listenable: _evaluationController,
          builder: (context, child) {
            return Stack(
              children: [
                SizedBox.expand(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: photos.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: 'photo-$index',
                        child: Image.file(
                          File(photos[index].path),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      spacing: 20,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Offstage(
                          offstage: _evaluationController.source == SourceTypes.fromSavedWithSign,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 125),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete, color: theme.onSurface),
                              onPressed: () async {
                                final bool isYes = await YesNoPicker.pick(
                                      context: context,
                                      question: 'Deseja excluir essa foto?',
                                    ) ??
                                    false;
                                if (isYes) {
                                  _evaluationController.removePhoto(_evaluationController.evaluation!.photos[_currentIndex]);
                                  await _evaluationController.updateImagesBytes();
                                  if (_evaluationController.evaluation!.photos.isEmpty && context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(photos.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _currentIndex == index ? 14.0 : 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentIndex == index ? theme.surface : theme.surface.withAlpha(125),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
