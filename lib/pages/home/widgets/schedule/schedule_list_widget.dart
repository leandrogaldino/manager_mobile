import 'package:flutter/material.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_tile_widget.dart';

class ScheduleListWidget extends StatelessWidget {
  const ScheduleListWidget({
    super.key,
    required this.schedules,
  });
  final List<VisitScheduleModel> schedules;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return ScheduleTileWidget(
          schedule: schedules[index],
        );
      },
    );
  }
}
