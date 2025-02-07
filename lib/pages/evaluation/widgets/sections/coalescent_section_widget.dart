import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';

class CoalescentSectionWidget extends StatefulWidget {
  final EvaluationModel evaluation;
  final EvaluationSource source;

  const CoalescentSectionWidget({
    super.key,
    required this.evaluation,
    required this.source,
  });

  @override
  State<CoalescentSectionWidget> createState() => _CoalescentSectionWidgetState();
}

class _CoalescentSectionWidgetState extends State<CoalescentSectionWidget> {
  late final EvaluationController evaluationController;

  @override
  void initState() {
    super.initState();
    evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: evaluationController,
        builder: (context, child) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
            ),
            child: Scrollbar(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.evaluation.coalescents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text(widget.evaluation.coalescents[index].coalescent.coalescentName),
                                    ListenableBuilder(
                                        listenable: evaluationController,
                                        builder: (context, child) {
                                          return TextButton(
                                            onPressed: () async {
                                              DateTime? selectedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );
                                              if (selectedDate != null) {
                                                evaluationController.setCoalescentNextChange(index, selectedDate);
                                              }
                                            },
                                            child: Text(
                                              widget.evaluation.coalescents[index].nextChange == null ? 'Selecionar Próxima Troca' : DateFormat('dd/MM/yyyy').format(widget.evaluation.coalescents[index].nextChange!),
                                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                            //TODO: a changedate do coalescente ta ficando null em algum momento.
                          ),
                          Divider(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
