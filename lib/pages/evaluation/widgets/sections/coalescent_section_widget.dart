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
          return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: widget.evaluation.coalescents.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.evaluation.coalescents[index].coalescent.coalescentName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        ListenableBuilder(
                            listenable: evaluationController,
                            builder: (context, child) {
                              return TextButton(
                                isSemanticButton: true,
                                onPressed: widget.source == EvaluationSource.fromSaved
                                    ? null
                                    : () async {
                                        FocusScope.of(context).requestFocus(FocusNode());
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
                    index != widget.evaluation.coalescents.length - 1
                        ? Divider(
                            color: Theme.of(context).colorScheme.primary,
                            height: 1,
                          )
                        : SizedBox.shrink(),
                  ],
                );
              });
        });
  }
}
