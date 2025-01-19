import 'package:flutter/material.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/home/widgets/evaluation/evaluation_tile_widget.dart';

class EvaluationListWidget extends StatelessWidget {
  const EvaluationListWidget({
    super.key,
    required this.evaluations,
  });
  final List<EvaluationModel> evaluations;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: evaluations.length,
      itemBuilder: (context, index) {
        return EvaluationTileWidget(
          evaluation: evaluations[index],
        );
      },
    );
  }
}
