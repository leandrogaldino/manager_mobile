import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/coalescent_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/expandable_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/header_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/instructions_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/performed_service_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/photo_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/reading_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/replaced_product_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/signature_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/technician_section_widget.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  late final GlobalKey<FormState> _readingKey;
  late final EvaluationController _controller;
  late final ScrollController _scrollController;
  final GlobalKey _coalescentKey = GlobalKey();
  final GlobalKey _replacedProductKey = GlobalKey();
  final GlobalKey _performedServiceKey = GlobalKey();
  final GlobalKey _technicianKey = GlobalKey();
  final GlobalKey _photoKey = GlobalKey();
  final GlobalKey _signatureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _readingKey = GlobalKey<FormState>();
    _scrollController = ScrollController();
    _controller = Locator.get<EvaluationController>();
    //if (_controller.source == SourceTypes.fromSavedWithSign ) {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      await _controller.updateImagesBytes();
    });
    //}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          alignment: 0.0,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String instructions = _controller.schedule != null ? _controller.schedule!.instructions : '';
    final bool showInstructions = _controller.source == SourceTypes.fromSchedule && _controller.schedule != null && _controller.schedule!.instructions.isNotEmpty;
    final bool showHeader = _controller.source == SourceTypes.fromSavedWithSign;
    final bool savedWithoutSign = _controller.source != SourceTypes.fromSavedWithoutSign;
    final bool showCoalescents = _controller.evaluation!.coalescents.isNotEmpty;

    final bool hasCompressor = _controller.evaluation!.compressor != null;
    final bool savedWithSign = _controller.source == SourceTypes.fromSavedWithSign;
    final bool hasReplacedProducts = _controller.evaluation!.replacedProducts.isNotEmpty;
    final bool hasPerformedServices = _controller.evaluation!.performedServices.isNotEmpty;
    final bool hasPhotos = _controller.evaluation!.photos.isNotEmpty;

    final bool showReplacedProducts = hasCompressor && (!savedWithSign || hasReplacedProducts);
    final bool showPerformedServices = hasCompressor && (!savedWithSign || hasPerformedServices);
    final bool showPhotos = hasCompressor && (!savedWithSign || hasPhotos);

    final bool showBottomBar = _controller.source != SourceTypes.fromSavedWithSign;

    return PopScope(
      canPop: _controller.source == SourceTypes.fromSavedWithSign,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          if (context.mounted) Navigator.pop(context, result);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Avaliação'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Visibility(
                  visible: showInstructions,
                  child: ExpandableSectionWidget(
                    initiallyExpanded: true,
                    title: 'Instruções',
                    children: [
                      InstructionsSectionWidget(
                        instructions: instructions,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showInstructions,
                  child: SizedBox(height: 5),
                ),
                Visibility(
                  visible: showHeader,
                  child: ExpandableSectionWidget(
                    title: 'Cabeçalho',
                    children: [
                      HeaderSectionWidget(evaluationController: _controller),
                    ],
                  ),
                ),
                Visibility(
                  visible: showHeader,
                  child: SizedBox(height: 5),
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return ExpandableSectionWidget(
                      initiallyExpanded: savedWithoutSign,
                      title: 'Dados do Compressor',
                      children: [ReadingSectionWidget(formKey: _readingKey, evaluationController: _controller)],
                    );
                  },
                ),
                SizedBox(height: 5),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Visibility(
                      visible: showCoalescents,
                      child: ExpandableSectionWidget(
                        key: _coalescentKey,
                        onExpand: () => _scrollToKey(_coalescentKey),
                        title: 'Coalescentes',
                        children: [
                          CoalescentSectionWidget(
                            evaluationController: _controller,
                          )
                        ],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Visibility(
                      visible: showCoalescents,
                      child: SizedBox(height: 5),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Visibility(
                      visible: showReplacedProducts,
                      child: ExpandableSectionWidget(
                        key: _replacedProductKey,
                        onExpand: () => _scrollToKey(_replacedProductKey),
                        title: 'Peças Substituídas',
                        children: [ReplacedProductSectionWidget(evaluationController: _controller)],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Visibility(
                      visible: showReplacedProducts,
                      child: SizedBox(height: 5),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Visibility(
                      visible: showPerformedServices,
                      child: ExpandableSectionWidget(
                        key: _performedServiceKey,
                        onExpand: () => _scrollToKey(_performedServiceKey),
                        title: 'Serviços Realizados',
                        children: [PerformedServiceSectionWidget(evaluationController: _controller)],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Visibility(
                      visible: showPerformedServices,
                      child: SizedBox(height: 5),
                    );
                  },
                ),
                ExpandableSectionWidget(
                  key: _technicianKey,
                  onExpand: () => _scrollToKey(_technicianKey),
                  title: 'Técnicos',
                  children: [TechnicianSectionWidget(evaluationController: _controller)],
                ),
                ListenableBuilder(
                    listenable: _controller,
                    builder: (context, child) {
                      return Visibility(
                        visible: _controller.evaluation!.technicians.isNotEmpty,
                        child: SizedBox(height: 5),
                      );
                    }),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Visibility(
                      visible: showPhotos,
                      child: ExpandableSectionWidget(
                        key: _photoKey,
                        onExpand: () => _scrollToKey(_photoKey),
                        title: 'Fotos',
                        children: [PhotoSectionWidget(evaluationController: _controller)],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Visibility(
                      visible: showPhotos,
                      child: SizedBox(height: 5),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return ExpandableSectionWidget(
                      key: _signatureKey,
                      initiallyExpanded: _controller.source == SourceTypes.fromSavedWithoutSign,
                      onExpand: () => _scrollToKey(_signatureKey),
                      title: 'Assinatura',
                      children: [SignatureSectionWidget(evaluationController: _controller)],
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return SizedBox(height: 5);
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: showBottomBar
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ListenableBuilder(
                        listenable: _controller,
                        builder: (context, child) {
                          return ElevatedButton(
                            onPressed: _controller.isSaving
                                ? null
                                : () async {
                                    final isValid = _readingKey.currentState?.validate() ?? false;
                                    if (!isValid) {
                                      Message.showInfoSnackbar(
                                        context: context,
                                        message: 'Verifique a seção de dados do compressor',
                                      );
                                      return;
                                    }
                                    if (!_validateCoalescentsNextChange(_controller)) return;
                                    await _controller.save();
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                  },
                            child: _controller.isSaving
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(
                                    'Salvar',
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: Theme.of(context).colorScheme.surface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                          );
                        }),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  bool _validateCoalescentsNextChange(EvaluationController controller) {
    final bool valid = controller.evaluation!.coalescents.every((coalescent) => coalescent.nextChange != null);
    if (!valid) {
      Message.showInfoSnackbar(context: context, message: 'Selecione a data da próxima troca de todos os coalescentes.');
    }
    return valid;
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const Text(
            'Todas as informações desta avaliação serão perdidas. Deseja realmente voltar?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Não'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Sim'),
              onPressed: () async {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
