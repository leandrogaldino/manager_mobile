import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_tile_widget.dart';

class ScheduleListWidget extends StatelessWidget {
  const ScheduleListWidget({
    super.key,
    required this.homeController,
    required this.scrollController,
  });
  final HomeController homeController;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final lastSuccess = homeController.lastSuccessState;
    var schedules = lastSuccess != null && lastSuccess.schedules.isNotEmpty ? lastSuccess.schedules : [];
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return ScheduleTileWidget(
          schedule: schedules[index],
        );
      },
    );
  }
}
