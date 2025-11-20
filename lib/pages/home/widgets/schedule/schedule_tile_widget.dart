import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_widget.dart';

class ScheduleTileWidget extends StatelessWidget {
  const ScheduleTileWidget({
    super.key,
    required this.schedule,
  });
  final VisitScheduleModel schedule;

  @override
  Widget build(BuildContext context) {
    String subtitle = schedule.compressor.compressor.name;
    schedule.compressor.serialNumber.isNotEmpty ? subtitle = '$subtitle - ${schedule.compressor.serialNumber}' : null;
    schedule.compressor.sector.isNotEmpty ? subtitle = '$subtitle - ${schedule.compressor.sector}' : null;
    String technician = schedule.technician.shortName;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          isThreeLine: true,
          title: Text(
            schedule.customer.shortName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              Text(
                technician,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ],
          ),
          trailing: Text(
            DateFormat('dd/MM/yyyy').format(schedule.scheduleDate),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                ),
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
