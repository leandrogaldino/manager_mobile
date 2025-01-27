import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/technician_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/preferences.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/pages/home/widgets/technician_chose/technician_choose_list_widget.dart';

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
  late final Preferences preferences;

  @override
  void initState() {
    super.initState();
    technicianController = Locator.get<TechnicianController>();
    preferences = Locator.get<Preferences>();
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
                        return AlertDialog(
                          title: Center(child: Text('Escolha o Técnico')),
                          content: SizedBox(
                            width: double.maxFinite,
                            height: 300,
                            child: TechnicianChoseListWidget(technicians: technicians),
                          ),
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
                  var evaluation = EvaluationModel.fromSchedule(widget.schedule);
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
