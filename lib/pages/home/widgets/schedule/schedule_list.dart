// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_tile.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({
    super.key,
    required this.schedules,
  });
  final List<ScheduleModel> schedules;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return ScheduleTile(schedule: schedules[index]);
      },
    );
  }
}
