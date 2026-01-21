import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';

class EvaluationTileWidget extends StatelessWidget {
  const EvaluationTileWidget({
    super.key,
    required this.evaluation,
    required this.evaluationController,
    required this.homeController,
  });

  final EvaluationModel evaluation;
  final EvaluationController evaluationController;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    String subtitle = evaluation.compressor!.compressor.name;
    if (evaluation.compressor!.serialNumber.isNotEmpty) {
      subtitle = '$subtitle - ${evaluation.compressor!.serialNumber}';
    }
    if (evaluation.compressor!.sector.isNotEmpty) {
      subtitle = '$subtitle - ${evaluation.compressor!.sector}';
    }
    String technicians = evaluation.technicians.map((e) => e.technician.shortName).toList().join(' • ');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () async {
            SourceTypes source = evaluation.signaturePath != null ? SourceTypes.fromSavedWithSign : SourceTypes.fromSavedWithoutSign;
            evaluationController.setEvaluation(evaluation, source);
            await Navigator.of(context).pushNamed(Routes.evaluation);            
            await homeController.loadInitial();
            evaluationController.clean();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 36,
                child: Center(
                  child: Icon(
                    evaluation.existsInCloud ? Icons.cloud_done : Icons.cloud_off,
                    color: Theme.of(context).colorScheme.surface,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evaluation.compressor!.person.shortName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      Text(
                        technicians,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd/MM/yyyy').format(evaluation.creationDate!),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
