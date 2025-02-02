import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/technician_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
import 'package:manager_mobile/pages/evaluation/widgets/expandable_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/header_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/instructions_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/reading_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/technician_section_widget.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({
    super.key,
    required this.evaluation,
    required this.source,
    this.instructions,
  });
  final EvaluationModel evaluation;
  final EvaluationSource source;
  final String? instructions;

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  late final GlobalKey<FormState> formKey;
  late final EvaluationController evaluationController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    evaluationController = Locator.get<EvaluationController>();
    evaluationController.setEvaluation(widget.evaluation);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.source == EvaluationSource.fromSaved,
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
                widget.source == EvaluationSource.fromSchedule && widget.instructions != null
                    ? ExpandableSectionWidget(
                        initiallyExpanded: true,
                        title: 'Instruções',
                        child: StructionsSectionWidget(instructions: widget.instructions!),
                      )
                    : SizedBox.shrink(),
                widget.source == EvaluationSource.fromSaved
                    ? ExpandableSectionWidget(
                        title: 'Cabeçalho',
                        child: HeaderSectionWidget(evaluation: widget.evaluation),
                      )
                    : SizedBox.shrink(),
                ExpandableSectionWidget(
                  initiallyExpanded: true,
                  title: 'Leitura',
                  child: ReadingSectionWidget(
                    evaluation: widget.evaluation,
                    source: widget.source,
                    formKey: formKey,
                  ),
                ),
                ExpandableSectionWidget(
                  title: 'Técnicos',
                  action: widget.source == EvaluationSource.fromSaved
                      ? null
                      : IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            PersonModel? technician = await TechnicianPicker.pick(context: context, hide: widget.evaluation.technicians.map((t) => t.technician).toList());
                            evaluationController.setEvaluation(widget.evaluation);

                            if (technician != null) evaluationController.addTechnician(EvaluationTechnicianModel(id: 0, isMain: false, technician: technician));
                          },
                        ),
                  child: TechnicianSectionWidget(evaluation: widget.evaluation),
                ),
                widget.source != EvaluationSource.fromSaved
                    ? ElevatedButton(
                        onPressed: () {
                          final valid = formKey.currentState?.validate() ?? false;
                          if (valid) {}
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
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
