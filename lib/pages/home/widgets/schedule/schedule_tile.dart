// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:manager_mobile/models/schedule_model.dart';

class ScheduleTile extends StatelessWidget {
  const ScheduleTile({
    super.key,
    required this.schedule,
  });
  final ScheduleModel schedule;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(schedule.customer.shortName),
    );
  }
}
