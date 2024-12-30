import 'package:flutter/material.dart';
import 'package:manager_mobile/models/schedule_model.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.schedule});

  final ScheduleModel schedule;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
