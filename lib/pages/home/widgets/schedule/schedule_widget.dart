import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/technician_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/core/widgets/technician_chose/technician_chose_dialog.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    super.key,
    required this.schedule,
  });

  final ScheduleModel schedule;

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  late final TechnicianController technicianController;
  late final AppPreferences preferences;

  @override
  void initState() {
    super.initState();
    technicianController = Locator.get<TechnicianController>();
    preferences = Locator.get<AppPreferences>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    text: widget.schedule.visitTypeString,
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
                    text: DateFormat('dd/MM/yyyy').format(widget.schedule.visitDate),
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
                    text: widget.schedule.customer.shortName,
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
                    text: widget.schedule.compressor.compressorName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            if (widget.schedule.instructions.isNotEmpty)
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
                      text: widget.schedule.instructions,
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
                        message: 'Não é possível iniciar uma avaliação sem informar um técnico.',
                      );
                    }
                    return;
                  }
                  var evaluation = EvaluationModel.fromSource(schedule: widget.schedule);
                  var loggedTechnician = await technicianController.getLoggedTechnician();
                  if (loggedTechnician != null) evaluation.technicians.add(EvaluationTechnicianModel(id: 0, isMain: true, technician: loggedTechnician));
                  if (!context.mounted) return;
                  Navigator.of(context).popAndPushNamed(
                    Routes.evaluation,
                    arguments: [evaluation, EvaluationSource.fromSchedule, widget.schedule.instructions],
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
