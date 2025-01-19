import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/home/widgets/evaluation/evaluation_widget.dart';

class EvaluationTileWidget extends StatelessWidget {
  const EvaluationTileWidget({
    super.key,
    required this.evaluation,
  });
  final EvaluationModel evaluation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          title: Text(
            evaluation.customer.shortName,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            '${evaluation.compressor.compressorName} - ${evaluation.compressor.serialNumber}',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Text(
            DateFormat('dd/MM/yyyy').format(evaluation.creationDate),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
          onTap: () async {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              builder: (context) {
                return EvaluationWidget(
                  evaluation: evaluation,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
