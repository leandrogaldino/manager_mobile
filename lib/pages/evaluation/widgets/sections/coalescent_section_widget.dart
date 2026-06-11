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
                        controller.source != SourceTypes.fromSavedWithSign ? getReadWrite(context, null, controller, index) : getReadOnly(context, null, controller, index)
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

  Widget getReadOnly(BuildContext context, Widget? child, EvaluationController controller, int index) {
    String text;

    if (controller.evaluation!.coalescents[index].ignoreNextChange == true) {
      text = 'IGNORADO';
    } else {
      String nextChange = DateTimeHelper.formatDate(controller.evaluation!.coalescents[index].nextChange!);
      text = nextChange;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }

  Widget getReadWrite(BuildContext context, Widget? child, EvaluationController controller, int index) {
    return TextButton(
      isSemanticButton: true,
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTimeHelper.now(),
          firstDate: DateTimeHelper.create(2000),
          lastDate: DateTimeHelper.create(2100),
        );
        if (selectedDate != null) {
          final spDate = DateTimeHelper.create(selectedDate.year, selectedDate.month, selectedDate.day);
          controller.setCoalescentNextChange(index, spDate);
        }
      },
      child: Column(
        children: [
          Visibility(
            visible: !controller.evaluation!.coalescents[index].ignoreNextChange,
            child: Text(
              controller.evaluation!.coalescents[index].nextChange == null ? 'SELECIONAR  PRÓXIMA TROCA' : DateFormat('dd/MM/yyyy').format(controller.evaluation!.coalescents[index].nextChange!),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: controller.evaluation!.coalescents[index].ignoreNextChange,
                onChanged: (value) {
                  controller.setIgnoreCoalescentNextChange(index, value!);
                },
              ),
              const Text('IGNORAR'),
            ],
          )
        ],
      ),
    );
  }
}
