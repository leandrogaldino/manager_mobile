import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';

class CoalescentSectionWidget extends StatefulWidget {
  const CoalescentSectionWidget({
    super.key,
  });

  @override
  State<CoalescentSectionWidget> createState() => _CoalescentSectionWidgetState();
}

class _CoalescentSectionWidgetState extends State<CoalescentSectionWidget> {
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _evaluationController,
        builder: (context, child) {
          return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _evaluationController.evaluation!.coalescents.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          _evaluationController.evaluation!.coalescents[index].coalescent.coalescentName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        ListenableBuilder(
                            listenable: _evaluationController,
                            builder: (context, child) {
                              return TextButton(
                                isSemanticButton: true,
                                onPressed: _evaluationController.source == EvaluationSource.fromSaved
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
                                          _evaluationController.setCoalescentNextChange(index, selectedDate);
                                        }
                                      },
                                child: Text(
                                  _evaluationController.evaluation!.coalescents[index].nextChange == null ? 'Selecionar Próxima Troca' : DateFormat('dd/MM/yyyy').format(_evaluationController.evaluation!.coalescents[index].nextChange!),
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                              );
                            }),
                      ],
                    ),
                    index != _evaluationController.evaluation!.coalescents.length - 1
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
