import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    super.key,
    required this.schedule,
    required this.homeController,
  });

  final VisitScheduleModel schedule;
  final HomeController homeController;
  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  late final LoginController _loginController;
  late final EvaluationController _evaluationController;
  PersonModel? _loggedUser;
  @override
  void initState() {
    super.initState();
    _loginController = Locator.get<LoginController>();
    _evaluationController = Locator.get<EvaluationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await _loginController.currentLoggedUser;
      if (!mounted) return;
      setState(() {
        _loggedUser = user;
      });
    });
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
                    text: widget.schedule.callType.stringValue,
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
                    text: DateFormat('dd/MM/yyyy').format(widget.schedule.scheduleDate),
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
                    text: widget.schedule.compressor.compressor.name,
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
              child: _loggedUser != null && _loggedUser!.isTechnician
                  ? ElevatedButton(
                      onPressed: () async {
                        var evaluation = EvaluationModel.fromScheduleOrNew(schedule: widget.schedule);
                        PersonModel? technician = await _loginController.currentLoggedUser;
                        if (technician != null) evaluation.technicians.add(EvaluationTechnicianModel(isMain: true, technician: technician));
                        if (!context.mounted) return;
                        _evaluationController.setEvaluation(evaluation, SourceTypes.fromSchedule);
                        _evaluationController.setSchedule(widget.schedule);
                        await Navigator.of(context).popAndPushNamed(Routes.evaluation, arguments: _evaluationController);
                        await widget.homeController.loadInitial();
                      },
                      child: Text('Iniciar Avaliação'),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
