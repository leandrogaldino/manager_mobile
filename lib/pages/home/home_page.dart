import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/filter_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/custom_appbar_widget.dart';
import 'package:manager_mobile/pages/home/widgets/evaluation/evaluation_list_widget.dart';
import 'package:manager_mobile/pages/home/widgets/filterbar/filterbar_widget.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppController appController;
  late final HomeController homeController;
  late final FilterController filterController;
  late final LoginController loginController;
  late final EvaluationController evaluationController;

  @override
  void initState() {
    super.initState();
    appController = Locator.get<AppController>();
    homeController = Locator.get<HomeController>();
    filterController = Locator.get<FilterController>();
    loginController = Locator.get<LoginController>();
    evaluationController = Locator.get<EvaluationController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeController.syncronize().asyncLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 5,
          children: [
            FilterBarWidget(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final result = await homeController.syncronize();
                  _showSyncResultSnackbar(result);
                },
                child: ListenableBuilder(
                  listenable: homeController,
                  builder: (context, child) {
                    return homeController.currentIndex == 0 ? ScheduleListWidget(schedules: homeController.schedules) : EvaluationListWidget(evaluations: homeController.evaluations);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: homeController,
        builder: (context, child) {
          return BottomNavigationBar(
            currentIndex: homeController.currentIndex,
            onTap: (index) {
              homeController.setCurrentIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "Agendamentos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.content_paste),
                label: "Avaliações",
              ),
            ],
          );
        },
      ),
      floatingActionButton: ListenableBuilder(
          listenable: homeController,
          builder: (context, child) {
            return homeController.currentIndex == 1
                ? FloatingActionButton(
                    onPressed: () async {
                      var evaluation = EvaluationModel.fromSource();
                      var loggedTechnician = await loginController.currentLoggedUser;
                      if (loggedTechnician != null) evaluation.technicians.add(EvaluationTechnicianModel(id: 0, isMain: true, technician: loggedTechnician));
                      if (!context.mounted) return;
                      Navigator.of(context).pushNamed(
                        Routes.evaluation,
                        arguments: [evaluation, EvaluationSource.fromNew],
                      );
                    },
                    child: Icon(Icons.add),
                  )
                : SizedBox.shrink();
          }),
    );
  }

  void _showSyncResultSnackbar(SyncronizeResultModel result) {
    String message = '';

    if (result.uploaded > 0) {
      message += result.uploaded == 1 ? 'Enviado: ${result.uploaded}' : 'Enviados: ${result.uploaded}';
    }

    if (result.downloaded > 0) {
      if (message.isNotEmpty) message += ' ';
      message += result.downloaded == 1 ? 'Baixado: ${result.downloaded}' : 'Baixados: ${result.downloaded}';
    }

    if (result.downloaded + result.uploaded > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Message.showSuccessSnackbar(context: context, message: message);
      });
    }
  }
}
