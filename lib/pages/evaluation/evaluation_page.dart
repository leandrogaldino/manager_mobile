import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
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
  const EvaluationPage({
    super.key,
    this.instructions,
  });

  final String? instructions;

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  late final GlobalKey<FormState> _readingKey;
  late final EvaluationController _evaluationController;
  late final HomeController _homeController;

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
    _scrollController = ScrollController(); // Inicializa o ScrollController
    _evaluationController = Locator.get<EvaluationController>();
    _homeController = Locator.get<HomeController>();
    if (_evaluationController.source == SourceTypes.fromSaved) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
        await _evaluationController.updateImagesBytes();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Não se esqueça de liberar o controller
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    // Usamos um post-frame callback para garantir que o widget já tenha sido renderizado (expandido)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          alignment: 0.0, // Rola o widget para o topo (0.0) ou meio (0.5) da tela
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _evaluationController.source == SourceTypes.fromSaved,
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
                  visible: _evaluationController.source == SourceTypes.fromSchedule && widget.instructions != null,
                  child: ExpandableSectionWidget(
                    initiallyExpanded: true,
                    title: 'Instruções',
                    children: [
                      InstructionsSectionWidget(
                        instructions: widget.instructions ?? '',
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _evaluationController.source == SourceTypes.fromSchedule && widget.instructions != null,
                  child: SizedBox(height: 5),
                ),
                Visibility(
                  visible: _evaluationController.source == SourceTypes.fromSaved,
                  child: ExpandableSectionWidget(
                    title: 'Cabeçalho',
                    children: [
                      HeaderSectionWidget(),
                    ],
                  ),
                ),
                Visibility(
                  visible: _evaluationController.source == SourceTypes.fromSaved,
                  child: SizedBox(height: 5),
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return ExpandableSectionWidget(
                      initiallyExpanded: true,
                      title: 'Dados do Compressor',
                      children: [ReadingSectionWidget(formKey: _readingKey)],
                    );
                  },
                ),
                SizedBox(height: 5),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.coalescents.isNotEmpty,
                      child: ExpandableSectionWidget(
                        key: _coalescentKey,
                        onExpand: () => _scrollToKey(_coalescentKey),
                        title: 'Coalescentes',
                        children: [CoalescentSectionWidget()],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.coalescents.isNotEmpty,
                      child: SizedBox(height: 5),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.compressor != null && ((_evaluationController.source == SourceTypes.fromSaved && _evaluationController.evaluation!.replacedProducts.isNotEmpty) || (_evaluationController.source != SourceTypes.fromSaved)),
                      child: ExpandableSectionWidget(
                        key: _replacedProductKey,
                        onExpand: () => _scrollToKey(_replacedProductKey),
                        title: 'Peças Substituídas',
                        children: [ReplacedProductSectionWidget()],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.compressor != null && ((_evaluationController.source == SourceTypes.fromSaved && _evaluationController.evaluation!.replacedProducts.isNotEmpty) || (_evaluationController.source != SourceTypes.fromSaved)),
                      child: SizedBox(height: 5),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.compressor != null && ((_evaluationController.source == SourceTypes.fromSaved && _evaluationController.evaluation!.performedServices.isNotEmpty) || (_evaluationController.source != SourceTypes.fromSaved)),
                      child: ExpandableSectionWidget(
                        key: _performedServiceKey,
                        onExpand: () => _scrollToKey(_performedServiceKey),
                        title: 'Serviços Realizados',
                        children: [PerformedServiceSectionWidget()],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.compressor != null && ((_evaluationController.source == SourceTypes.fromSaved && _evaluationController.evaluation!.performedServices.isNotEmpty) || (_evaluationController.source != SourceTypes.fromSaved)),
                      child: SizedBox(height: 5),
                    );
                  },
                ),
                ExpandableSectionWidget(
                  key: _technicianKey,
                  onExpand: () => _scrollToKey(_technicianKey),
                  title: 'Técnicos',
                  children: [TechnicianSectionWidget()],
                ),
                ListenableBuilder(
                    listenable: _evaluationController,
                    builder: (context, child) {
                      return Visibility(
                        visible: _evaluationController.evaluation!.technicians.isNotEmpty,
                        child: SizedBox(height: 5),
                      );
                    }),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.compressor != null && ((_evaluationController.source == SourceTypes.fromSaved && _evaluationController.evaluation!.photos.isNotEmpty) || (_evaluationController.source != SourceTypes.fromSaved)),
                      child: ExpandableSectionWidget(
                        key: _photoKey,
                        onExpand: () => _scrollToKey(_photoKey),
                        title: 'Fotos',
                        children: [PhotoSectionWidget()],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.compressor != null && ((_evaluationController.source == SourceTypes.fromSaved && _evaluationController.evaluation!.photos.isNotEmpty) || (_evaluationController.source != SourceTypes.fromSaved)),
                      child: SizedBox(height: 5),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.compressor != null &&
                          ((_evaluationController.source == SourceTypes.fromSaved && _evaluationController.evaluation!.signaturePath != null && _evaluationController.evaluation!.signaturePath!.isNotEmpty) || (_evaluationController.source != SourceTypes.fromSaved)),
                      child: ExpandableSectionWidget(
                        key: _signatureKey,
                        onExpand: () => _scrollToKey(_signatureKey),
                        title: 'Assinatura',
                        children: [SignatureSectionWidget()],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _evaluationController,
                  builder: (context, child) {
                    return Visibility(
                      visible: _evaluationController.evaluation!.compressor != null &&
                          ((_evaluationController.source == SourceTypes.fromSaved && _evaluationController.evaluation!.signaturePath != null && _evaluationController.evaluation!.signaturePath!.isNotEmpty) || (_evaluationController.source != SourceTypes.fromSaved)),
                      child: SizedBox(height: 5),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _evaluationController.source != SourceTypes.fromSaved
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  // ↑        ↑
                  // left   espaço acima do botão (24px)
                  // right  espaço inferior (16px)
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValid = _readingKey.currentState?.validate() ?? false;

                        if (!isValid) {
                          Message.showInfoSnackbar(
                            context: context,
                            message: 'Verifique a seção de dados do compressor',
                          );
                          return;
                        }
                        if (!_validateCoalescentsNextChange()) return;
                        if (!_validateSignature()) return;
                        await _evaluationController.save();

                        await _evaluationController.refreshData();
                        await _homeController.applyFilters();

                        if (!context.mounted) return;
                        Navigator.pop<EvaluationModel>(context);
                      },
                      child: Text(
                        'Salvar',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  bool _validateSignature() {
    final bool valid = _evaluationController.signatureBytes != null;
    if (!valid) {
      Message.showInfoSnackbar(context: context, message: 'Assinatura do cliente necessária para salvar.');
    }
    return valid;
  }

  bool _validateCoalescentsNextChange() {
    final bool valid = _evaluationController.evaluation!.coalescents.every((coalescent) => coalescent.nextChange != null);
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
