import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';

class HeaderSectionWidget extends StatelessWidget {
  const HeaderSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final EvaluationController evaluationController = Locator.get<EvaluationController>();
    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'ID: ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: evaluationController.evaluation!.importedId == null ? 'Não importada' : evaluationController.evaluation!.importedId!.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Criação: ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: DateFormat('dd/MM/yyyy').format(evaluationController.evaluation!.creationDate!),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Inicio: ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: evaluationController.evaluation!.startTime!.format(context),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Fim: ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: evaluationController.evaluation!.endTime!.format(context),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
