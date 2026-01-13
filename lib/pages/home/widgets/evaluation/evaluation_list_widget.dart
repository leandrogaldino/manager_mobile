import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/pages/home/widgets/evaluation/evaluation_tile_widget.dart';

class EvaluationListWidget extends StatelessWidget {
  const EvaluationListWidget({
    super.key,
    required this.homeController,
    required this.scrollController,
  });
  final HomeController homeController;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final lastSuccess = homeController.lastSuccessState;
    var evaluations = lastSuccess != null && lastSuccess.evaluations.isNotEmpty ? lastSuccess.evaluations : [];

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: evaluations.length,
      itemBuilder: (context, index) {
        return EvaluationTileWidget(
          evaluation: evaluations[index],
        );
      },
    );
  }
}
