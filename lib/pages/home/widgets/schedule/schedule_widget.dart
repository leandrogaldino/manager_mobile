import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/technician_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/core/widgets/technician_chose/technician_chose_dialog.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/schedule_model.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({
    super.key,
    required this.schedule,
  });

  final ScheduleModel schedule;

  @override
  Widget build(BuildContext context) {
    final TechnicianController technicianController = Locator.get<TechnicianController>();
    final AppPreferences preferences = Locator.get<AppPreferences>();
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: 48,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Tipo de Visita: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: schedule.visitTypeString,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Data Marcada: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: DateFormat('dd/MM/yyyy').format(schedule.visitDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Cliente: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: schedule.customer.shortName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Compressor: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: schedule.compressor.compressorName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            if (schedule.instructions.isNotEmpty)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Instruções: ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: schedule.instructions,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  var logged = await preferences.getLoggedTechnicianId;
                  if (logged == 0) {
                    var technicians = await technicianController.getTechnicians();

                    if (!context.mounted) return;
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return TechnicianChooseDialog(
                          technicians: technicians,
                          loggedTechnician: technicianController.loggedTechnicianId,
                        );
                      },
                    );
                    logged = await preferences.getLoggedTechnicianId;
                  }
                  if (logged == 0) {
                    if (context.mounted) {
                      Message.showInfoSnackbar(
                        context: context,
                        message: 'Não é possível iniciar uma avaliação sem informar quem você é.',
                      );
                    }
                    return;
                  }
                  if (!context.mounted) return;
                  var evaluation = EvaluationModel.fromSchedule(schedule);
                  Navigator.of(context).popAndPushNamed(
                    Routes.evaluation,
                    arguments: evaluation,
                  );
                },
                child: Text('Iniciar Avaliação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
