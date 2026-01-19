import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/core/enums/source_types.dart';

class CoalescentSectionWidget extends StatefulWidget {
  const CoalescentSectionWidget({
    super.key,
    required this.evaluationController,
  });

  final EvaluationController evaluationController;

  @override
  State<CoalescentSectionWidget> createState() => _CoalescentSectionWidgetState();
}

class _CoalescentSectionWidgetState extends State<CoalescentSectionWidget> {
  @override
  Widget build(BuildContext context) {
    EvaluationController controller = widget.evaluationController;
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: controller.evaluation!.coalescents.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          controller.evaluation!.coalescents[index].coalescent.product.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        ListenableBuilder(
                            listenable: controller,
                            builder: (context, child) {
                              return TextButton(
                                isSemanticButton: true,
                                onPressed: controller.source == SourceTypes.fromSavedWithSign
                                    ? null
                                    : () async {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        DateTime? selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTimeHelper.now(),
                                          firstDate: DateTimeHelper.create(2000),
                                          lastDate: DateTimeHelper.create(2100),
                                        );
                                        if (selectedDate != null) {
                                          controller.setCoalescentNextChange(index, selectedDate);
                                        }
                                      },
                                child: Text(
                                  controller.evaluation!.coalescents[index].nextChange == null ? 'Selecionar Próxima Troca' : DateFormat('dd/MM/yyyy').format(controller.evaluation!.coalescents[index].nextChange!),
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                              );
                            }),
                      ],
                    ),
                    index != controller.evaluation!.coalescents.length - 1
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
