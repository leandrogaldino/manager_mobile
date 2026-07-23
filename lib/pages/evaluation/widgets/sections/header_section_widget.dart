import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';

class HeaderSectionWidget extends StatelessWidget {
  const HeaderSectionWidget({
    super.key,
    required this.evaluationController,
  });

  final EvaluationController evaluationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'ID CLOUD: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: evaluationController.evaluation!.id == null ? 'N/A' : evaluationController.evaluation!.id!.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'ID LOCAL: ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: evaluationController.evaluation!.importedId == null ? 'N/A' : evaluationController.evaluation!.importedId!.toString(),
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
