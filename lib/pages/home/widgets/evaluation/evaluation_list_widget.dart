import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/pages/home/widgets/evaluation/evaluation_tile_widget.dart';

class EvaluationListWidget extends StatelessWidget {
  const EvaluationListWidget({
    super.key,
    required this.homeController,
    required this.scrollController,
    required this.evaluationController,
  });
  final HomeController homeController;
  final EvaluationController evaluationController;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    var evaluations = homeController.evaluations;

    return ListenableBuilder(
        listenable: homeController.evaluations,
        builder: (context, child) {
          return ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: evaluations.items.length,
            itemBuilder: (context, index) {
              return EvaluationTileWidget(
                evaluation: evaluations.items[index],
                evaluationController: evaluationController,
                homeController: homeController,
              );
            },
          );
        });
  }
}
