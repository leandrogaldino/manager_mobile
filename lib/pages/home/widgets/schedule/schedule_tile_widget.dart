// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_widget.dart';

class ScheduleTileWidget extends StatelessWidget {
  const ScheduleTileWidget({
    super.key,
    required this.schedule,
  });
  final ScheduleModel schedule;

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
            schedule.customer.shortName,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            '${schedule.compressor.compressorName} - ${schedule.compressor.serialNumber}',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Text(
            DateFormat('dd/MM/yyyy').format(schedule.visitDate),
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
                return ScheduleWidget(
                  schedule: schedule,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
