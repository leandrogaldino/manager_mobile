import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/controllers/person_controller.dart';
import 'package:manager_mobile/core/helper/compressor_picker.dart';
import 'package:manager_mobile/core/helper/technician_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
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
  late final GlobalKey<FormState> formKey;
  late final LoginController loginController;
  late final EvaluationController evaluationController;
  late final PersonController personController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    loginController = Locator.get<LoginController>();
    evaluationController = Locator.get<EvaluationController>();
    personController = Locator.get<PersonController>();
    if (evaluationController.source == EvaluationSource.fromSaved) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
        final signaturePath = evaluationController.evaluation!.signaturePath;
        if (signaturePath != null && await File(signaturePath).exists()) {
          var signatureBytes = await File(signaturePath).readAsBytes();
          evaluationController.setSignatureBytes(signatureBytes);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: evaluationController.source == EvaluationSource.fromSaved,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context, result);
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
                  visible: evaluationController.source == EvaluationSource.fromSchedule && widget.instructions != null,
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
                  visible: evaluationController.source == EvaluationSource.fromSchedule && widget.instructions != null,
                  child: SizedBox(height: 5),
                ),
                Visibility(
                  visible: evaluationController.source == EvaluationSource.fromSaved,
                  child: ExpandableSectionWidget(
                    title: Text('Cabeçalho'),
                    children: [HeaderSectionWidget(evaluation: evaluationController.evaluation!)],
                  ),
                ),
                Visibility(
                  visible: evaluationController.source == EvaluationSource.fromSaved,
                  child: SizedBox(height: 5),
                ),
                ListenableBuilder(
                    listenable: evaluationController,
                    builder: (context, child) {
                      return ExpandableSectionWidget(
                        initiallyExpanded: true,
                        title: Text('Dados do Compressor'),
                        children: [
                          ReadingSectionWidget(
                            evaluation: evaluationController.evaluation!,
                            source: evaluationController.source!,
                            formKey: formKey,
                          )
                        ],
                      );
                    }),
                SizedBox(height: 5),
                ListenableBuilder(
                    listenable: evaluationController,
                    builder: (context, child) {
                      return Visibility(
                        visible: evaluationController.evaluation!.coalescents.isNotEmpty,
                        child: ExpandableSectionWidget(
                          title: Text('Coalescentes'),
                          children: [
                            CoalescentSectionWidget(
                              evaluation: evaluationController.evaluation!,
                              source: evaluationController.source!,
                            )
                          ],
                        ),
                      );
                    }),
                Visibility(
                  visible: evaluationController.evaluation!.coalescents.isNotEmpty,
                  child: SizedBox(height: 5),
                ),
                ExpandableSectionWidget(
                  title: Text('Técnicos'),
                  children: [
                    TechnicianSectionWidget(
                      evaluation: evaluationController.evaluation!,
                      source: evaluationController.source!,
                    )
                  ],
                ),
                SizedBox(height: 5),
                ExpandableSectionWidget(
                  title: Text('Fotos'),
                  children: [
                    PhotoSectionWidget(
                      evaluation: evaluationController.evaluation!,
                      source: evaluationController.source!,
                    )
                  ],
                ),
                SizedBox(height: 5),
                ExpandableSectionWidget(
                  title: Text('Assinatura'),
                  children: [
                    SignatureSectionWidget(
                      evaluation: evaluationController.evaluation!,
                      source: evaluationController.source!,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: evaluationController.source != EvaluationSource.fromSaved
            ? Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isValid = formKey.currentState?.validate() ?? false;
                      if (!isValid) {
                        Message.showInfoSnackbar(
                          context: context,
                          message: 'Verifique a seção de leitura',
                        );
                        return;
                      }
                      if (!_validateCoalescentsNextChange()) return;
                      if (!_validateSignature()) return;

                      await evaluationController.save();
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
    final bool valid = evaluationController.signatureBytes != null;
    if (!valid) {
      Message.showInfoSnackbar(context: context, message: 'Assinatura do cliente necessária para salvar.');
    }
    return valid;
  }

  bool _validateCoalescentsNextChange() {
    final bool valid = evaluationController.evaluation!.coalescents.every((coalescent) => coalescent.nextChange != null);
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
