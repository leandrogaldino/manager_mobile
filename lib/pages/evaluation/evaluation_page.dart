import 'package:flutter/material.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/evaluation/widgets/expandable_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/reading_section_widget.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key, required this.evaluation});

  final EvaluationModel evaluation;

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliação'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ExpandableSectionWidget(
                initiallyExpanded: true,
                title: 'Leitura',
                child: ReadingSectionWidget(
                  evaluation: widget.evaluation,
                  formKey: formKey,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    final valid = formKey.currentState?.validate() ?? false;
                    if (valid) {}
                  },
                  child: Text('Salvar'))
            ],
          ),
        ),
      ),
    );
  }
}
