import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';

class EvaluationTileWidget extends StatelessWidget {
  const EvaluationTileWidget({
    super.key,
    required this.evaluation,
  });

  final EvaluationModel evaluation;

  @override
  Widget build(BuildContext context) {
    final evaluationController = Locator.get<EvaluationController>();
    String subtitle = evaluation.personCompressor!.compressor.name;
    evaluation.personCompressor!.serialNumber.isNotEmpty ? subtitle = '$subtitle - ${evaluation.personCompressor!.serialNumber}' : null;
    evaluation.personCompressor!.sector.isNotEmpty ? subtitle = '$subtitle - ${evaluation.personCompressor!.sector}' : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          leading: Icon(
            evaluation.existsInCloud ? Icons.cloud_done : Icons.cloud_off,
            color: Theme.of(context).colorScheme.surface,
          ),
          title: Text(
            evaluation.personCompressor!.person.shortName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          trailing: Text(
            DateFormat('dd/MM/yyyy').format(evaluation.creationDate!),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                ),
          ),
          onTap: () {
            evaluationController.setEvaluation(evaluation, SourceTypes.fromSaved);
            Navigator.of(context).pushNamed(Routes.evaluation);
          },
        ),
      ),
    );
  }
}
