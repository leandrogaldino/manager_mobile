import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_widget.dart';

class ScheduleTileWidget extends StatelessWidget {
  const ScheduleTileWidget({
    super.key,
    required this.schedule,
    required this.homeController,
  });

  final VisitScheduleModel schedule;
  final HomeController homeController;
  @override
  Widget build(BuildContext context) {
    String subtitle = schedule.compressor.compressor.name;

    if (schedule.compressor.serialNumber.isNotEmpty) {
      subtitle = '$subtitle - ${schedule.compressor.serialNumber}';
    }
    if (schedule.compressor.sector.isNotEmpty) {
      subtitle = '$subtitle - ${schedule.compressor.sector}';
    }

    String technician = schedule.technician.shortName;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () async {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              builder: (context) {
                return ScheduleWidget(
                  schedule: schedule,
                  homeController: homeController,
                );
              },
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // ÍCONE CENTRALIZADO
            children: [
              // TÍTULO + SUBTÍTULOS
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.customer.shortName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                ),
              ),

              // TRAILING — DATA
              const SizedBox(width: 8),
              Text(
                DateFormat('dd/MM/yyyy').format(schedule.scheduleDate),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
