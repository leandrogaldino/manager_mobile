import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/loader_widget.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
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
  late final HomeController _homeController;
  late final LoginController _loginController;
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _homeController = Locator.get<HomeController>();
    _loginController = Locator.get<LoginController>();
    _evaluationController = Locator.get<EvaluationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _homeController.syncronize().asyncLoader();
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
                  await _homeController.syncronize().asyncLoader(customLoader: LoaderWidget(message: 'Sincronizando'));
                },
                child: ListenableBuilder(
                  listenable: _homeController,
                  builder: (context, child) {
                    return _homeController.currentIndex == 0 ? ScheduleListWidget(schedules: _homeController.schedules) : EvaluationListWidget(evaluations: _homeController.evaluations);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _homeController,
        builder: (context, child) {
          return BottomNavigationBar(
            currentIndex: _homeController.currentIndex,
            onTap: (index) {
              _homeController.setCurrentIndex(index);
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
          listenable: _homeController,
          builder: (context, child) {
            return _homeController.currentIndex == 1
                ? FloatingActionButton(
                    onPressed: () async {
                      var evaluation = EvaluationModel.fromScheduleOrNew();
                      var loggedTechnician = await _loginController.currentLoggedUser;
                      if (loggedTechnician != null) evaluation.technicians.add(EvaluationTechnicianModel(isMain: true, technician: loggedTechnician));
                      _evaluationController.setEvaluation(evaluation, SourceTypes.fromNew);
                      if (!context.mounted) return;
                      Navigator.of(context).pushNamed(Routes.evaluation);
                    },
                    child: Icon(Icons.add),
                  )
                : SizedBox.shrink();
          }),
    );
  }
}
