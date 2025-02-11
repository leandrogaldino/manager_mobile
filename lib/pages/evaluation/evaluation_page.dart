import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/coalescent_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/expandable_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/header_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/instructions_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/photo_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/reading_section_widget.dart';
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
  late final GlobalKey<FormState> _formKey;
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _evaluationController = Locator.get<EvaluationController>();
    if (_evaluationController.source == EvaluationSource.fromSaved) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
        await _evaluationController.updateImagesBytes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _evaluationController.source == EvaluationSource.fromSaved,
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
                  visible: _evaluationController.source == EvaluationSource.fromSchedule && widget.instructions != null,
                  child: ExpandableSectionWidget(
                    initiallyExpanded: true,
                    title: Text('Instruções'),
                    children: [
                      InstructionsSectionWidget(
                        instructions: widget.instructions ?? '',
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _evaluationController.source == EvaluationSource.fromSchedule && widget.instructions != null,
                  child: SizedBox(height: 5),
                ),
                Visibility(
                  visible: _evaluationController.source == EvaluationSource.fromSaved,
                  child: ExpandableSectionWidget(
                    title: Text('Cabeçalho'),
                    children: [
                      HeaderSectionWidget(),
                    ],
                  ),
                ),
                Visibility(
                  visible: _evaluationController.source == EvaluationSource.fromSaved,
                  child: SizedBox(height: 5),
                ),
                ListenableBuilder(
                    listenable: _evaluationController,
                    builder: (context, child) {
                      return ExpandableSectionWidget(
                        initiallyExpanded: true,
                        title: Text('Dados do Compressor'),
                        children: [
                          ReadingSectionWidget(
                            formKey: _formKey,
                          )
                        ],
                      );
                    }),
                SizedBox(height: 5),
                ListenableBuilder(
                    listenable: _evaluationController,
                    builder: (context, child) {
                      return Visibility(
                        visible: _evaluationController.evaluation!.coalescents.isNotEmpty,
                        child: ExpandableSectionWidget(
                          title: Text('Coalescentes'),
                          children: [
                            CoalescentSectionWidget(),
                          ],
                        ),
                      );
                    }),
                ListenableBuilder(
                    listenable: _evaluationController,
                    builder: (context, child) {
                      return Visibility(
                        visible: _evaluationController.evaluation!.coalescents.isNotEmpty,
                        child: SizedBox(height: 5),
                      );
                    }),
                ExpandableSectionWidget(
                  title: Text('Técnicos'),
                  children: [
                    TechnicianSectionWidget(),
                  ],
                ),
                SizedBox(height: 5),
                ListenableBuilder(
                    listenable: _evaluationController,
                    builder: (context, child) {
                      return Visibility(
                        visible: (_evaluationController.source == EvaluationSource.fromSaved && _evaluationController.evaluation!.photoPaths.isNotEmpty) || (_evaluationController.source != EvaluationSource.fromSaved),
                        child: ExpandableSectionWidget(
                          title: Text('Fotos'),
                          children: [
                            PhotoSectionWidget(),
                          ],
                        ),
                      );
                    }),
                ListenableBuilder(
                    listenable: _evaluationController,
                    builder: (context, child) {
                      return Visibility(
                        visible: (_evaluationController.source == EvaluationSource.fromSaved && _evaluationController.evaluation!.photoPaths.isNotEmpty) || (_evaluationController.source != EvaluationSource.fromSaved),
                        child: SizedBox(height: 5),
                      );
                    }),
                ExpandableSectionWidget(
                  title: Text('Assinatura'),
                  children: [
                    SignatureSectionWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _evaluationController.source != EvaluationSource.fromSaved
            ? Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isValid = _formKey.currentState?.validate() ?? false;
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
                      if (!context.mounted) return;
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
