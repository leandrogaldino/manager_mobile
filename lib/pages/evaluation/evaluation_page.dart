import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/helper/technician_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/coalescent_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/expandable_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/header_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/sections/instructions_section_widget.dart';
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

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    loginController = Locator.get<LoginController>();
    evaluationController = Locator.get<EvaluationController>();

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                evaluationController.source == EvaluationSource.fromSchedule && widget.instructions != null
                    ? ExpandableSectionWidget(
                        initiallyExpanded: true,
                        title: 'Instruções',
                        child: StructionsSectionWidget(instructions: widget.instructions!),
                      )
                    : SizedBox.shrink(),
                evaluationController.source == EvaluationSource.fromSaved
                    ? ExpandableSectionWidget(
                        title: 'Cabeçalho',
                        child: HeaderSectionWidget(evaluation: evaluationController.evaluation!),
                      )
                    : SizedBox.shrink(),
                ExpandableSectionWidget(
                  initiallyExpanded: true,
                  title: 'Leitura',
                  child: ReadingSectionWidget(
                    evaluation: evaluationController.evaluation!,
                    source: evaluationController.source!,
                    formKey: formKey,
                  ),
                ),
                ListenableBuilder(
                    listenable: evaluationController,
                    builder: (context, child) {
                      return Offstage(
                        offstage: evaluationController.evaluation!.coalescents.isEmpty,
                        child: ExpandableSectionWidget(
                          title: 'Coalescentes',
                          child: CoalescentSectionWidget(
                            evaluation: evaluationController.evaluation!,
                            source: evaluationController.source!,
                          ),
                        ),
                      );
                    }),
                ExpandableSectionWidget(
                  title: 'Técnicos',
                  action: evaluationController.source == EvaluationSource.fromSaved
                      ? null
                      : IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          onPressed: () async {
                            PersonModel? technician = await TechnicianPicker.pick(context: context);
                            if (technician != null) evaluationController.addTechnician(EvaluationTechnicianModel(id: 0, isMain: false, technician: technician));
                          },
                        ),
                  child: TechnicianSectionWidget(
                    evaluation: evaluationController.evaluation!,
                    source: evaluationController.source!,
                  ),
                ),
                ExpandableSectionWidget(
                  title: 'Assinatura',
                  child: SignatureSectionWidget(
                    evaluation: evaluationController.evaluation!,
                    source: evaluationController.source!,
                  ),
                ),
                evaluationController.source != EvaluationSource.fromSaved
                    ? ElevatedButton(
                        onPressed: () async {
                          bool valid = formKey.currentState?.validate() ?? false;
                          if (valid) valid = _validateCoalescentsNextChange();
                          if (valid) valid = _validateSignature();
                          if (valid) {
                            await evaluationController.save();
                            if (!context.mounted) return;
                          }
                        },
                        child: Text('Salvar'))
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
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
