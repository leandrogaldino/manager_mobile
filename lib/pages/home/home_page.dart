import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/timers/synchronize_timer.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/custom_appbar_widget.dart';
import 'package:manager_mobile/pages/home/widgets/evaluation/evaluation_list_widget.dart';
import 'package:manager_mobile/pages/home/widgets/filterbar/filterbar_widget.dart';
import 'package:manager_mobile/pages/home/widgets/loader_widget.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_list_widget.dart';
import 'package:manager_mobile/states/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final HomeController _homeController;
  late final LoginController _loginController;
  late final EvaluationController _evaluationController;
  late final AppPreferences _appPreferences;
  late final StreamSubscription<InternetStatus> _connectionSubscription;
  bool _hasShownError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeController = Locator.get<HomeController>();
    _loginController = Locator.get<LoginController>();
    _evaluationController = Locator.get<EvaluationController>();
    _appPreferences = Locator.get<AppPreferences>();
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) async {
      if (status == InternetStatus.disconnected && _homeController.synchronizing) {
        log('AppLifecycleState: App perdeu a conexao com a internet. Salvando estado...', time: DateTime.now());
        await _appPreferences.setIgnoreLastSynchronize(true);
        log('Estado salvo com sucesso. O valor de ignoreLastSync é: ${await _appPreferences.ignoreLastSynchronize}', time: DateTime.now());
      }
    });
    SynchronizeTimer.start();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _homeController.synchronize(showLoading: true);
    });
  }

  @override
  void dispose() {
    SynchronizeTimer.stop();
    _connectionSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if ((state == AppLifecycleState.paused || state == AppLifecycleState.hidden) && _homeController.synchronizing) {
      log('AppLifecycleState: App entrando em Background. Salvando estado...', time: DateTime.now());
      await _appPreferences.setIgnoreLastSynchronize(true);

      log('Estado salvo com sucesso. O valor de ignoreLastSync é: ${await _appPreferences.ignoreLastSynchronize}', time: DateTime.now());
    }
    if (state == AppLifecycleState.resumed) {
      log('AppLifecycleState: App voltando para Foreground.', time: DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListenableBuilder(
          listenable: _homeController,
          builder: (context, child) {
            final state = _homeController.state;
            final lastSuccess = _homeController.lastSuccessState;

            // 1. Se erro → mostra snackbar, mas não altera UI
            if (state is HomeStateError && !_hasShownError) {
              _hasShownError = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Message.showErrorSnackbar(
                  context: context,
                  message: state.errorMessage,
                );
              });
            }

            if (state is HomeStateInfo) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Message.showInfoSnackbar(
                  context: context,
                  message: state.infoMessage,
                );
              });
            }

            // 2. Loading real (quando ainda não teve sucesso nenhum)
            if (state is HomeStateLoading && lastSuccess == null) {
              return LoaderWidget();
            }

            // 3. Aqui mostra SEMPRE os dados do último sucesso

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FilterBarWidget(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _hasShownError = false;
                        await _homeController.synchronize();
                      },
                      child: _homeController.currentIndex == 0
                          ? ScheduleListWidget(schedules: lastSuccess != null && lastSuccess.schedules.isNotEmpty ? lastSuccess.schedules : [])
                          : EvaluationListWidget(evaluations: lastSuccess != null && lastSuccess.evaluations.isNotEmpty ? lastSuccess.evaluations : []),
                    ),
                  ),
                ],
              ),
            );

            // fallback: nunca deve ocorrer
            // return SizedBox.shrink();
          }),
      bottomNavigationBar: ListenableBuilder(
        listenable: _homeController,
        builder: (context, child) {
          final state = _homeController.state;
          if (state is HomeStateLoading) return SizedBox.shrink();

          return BottomNavigationBar(
            currentIndex: _homeController.currentIndex,
            onTap: (index) {
              _homeController.setCurrentIndex(index);
            },
            items: const [
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
              ? Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        spreadRadius: 10,
                        offset: Offset(0, 3),
                        color: Color.fromARGB(66, 0, 0, 0),
                      )
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () async {
                      var evaluation = EvaluationModel.fromScheduleOrNew();
                      var loggedTechnician = await _loginController.currentLoggedUser;

                      if (loggedTechnician != null) {
                        evaluation.technicians.add(
                          EvaluationTechnicianModel(
                            isMain: true,
                            technician: loggedTechnician,
                          ),
                        );
                      }

                      _evaluationController.setEvaluation(evaluation, SourceTypes.fromNew);

                      if (!context.mounted) return;

                      Navigator.of(context).pushNamed(Routes.evaluation);
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
