import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
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
  late final ScrollController _visitScheduleScrollController;
  late final ScrollController _evaluationScrollController;

  bool _hasShownError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeController = Locator.get<HomeController>();
    _loginController = Locator.get<LoginController>();
    _evaluationController = Locator.get<EvaluationController>();
    _appPreferences = Locator.get<AppPreferences>();

    _visitScheduleScrollController = ScrollController();
    _visitScheduleScrollController.addListener(() {
      if (_visitScheduleScrollController.position.pixels >= _visitScheduleScrollController.position.maxScrollExtent - 200) {
        _homeController.visitSchedules.loadMore();
      }
    });
    _evaluationScrollController = ScrollController();
    _evaluationScrollController.addListener(() {
      if (_evaluationScrollController.position.pixels >= _evaluationScrollController.position.maxScrollExtent - 200) {
        _homeController.evaluations.loadMore();
      }
    });
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) async {
      if (status == InternetStatus.disconnected && _homeController.synchronizing) {
        log('AppLifecycleState: App perdeu a conexao com a internet. Salvando estado...', time: DateTimeHelper.now());
        await _appPreferences.setIgnoreLastSynchronize(true);
        log('Estado salvo com sucesso. O valor de ignoreLastSync é: ${await _appPreferences.ignoreLastSynchronize}', time: DateTimeHelper.now());
      }
    });
    SynchronizeTimer.start();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _homeController.synchronize(showLoading: true);
      await _homeController.loadInitial();
    });
  }

  @override
  void dispose() {
    SynchronizeTimer.stop();
    _evaluationScrollController.dispose();
    _visitScheduleScrollController.dispose();
    _connectionSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if ((state == AppLifecycleState.paused || state == AppLifecycleState.hidden) && _homeController.synchronizing) {
      log('AppLifecycleState: App entrando em Background. Salvando estado...', time: DateTimeHelper.now());
      await _appPreferences.setIgnoreLastSynchronize(true);
      log('Estado salvo com sucesso. O valor de ignoreLastSync é: ${await _appPreferences.ignoreLastSynchronize}', time: DateTimeHelper.now());
    }
    if (state == AppLifecycleState.resumed) {
      log('AppLifecycleState: App voltando para Foreground.', time: DateTimeHelper.now());
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
            showMessage(state);
            if (state is HomeStateLoading && lastSuccess == null) {
              return LoaderWidget();
            }
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
                        await _homeController.loadInitial();
                      },
                      child: _homeController.currentIndex == 0
                          ? ScheduleListWidget(
                              homeController: _homeController,
                              scrollController: _visitScheduleScrollController,
                            )
                          : EvaluationListWidget(
                              homeController: _homeController,
                              scrollController: _evaluationScrollController,
                            ),
                    ),
                  ),
                ],
              ),
            );
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
                      _evaluationController.setEvaluation(evaluation, SourceTypes.fromNew);
                      var loggedTechnician = await _loginController.currentLoggedUser;
                      _evaluationController.addTechnician(
                        EvaluationTechnicianModel(
                          isMain: true,
                          technician: loggedTechnician!,
                        ),
                      );

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

  void showMessage(HomeState state) {
    if (state is HomeStateError && !_hasShownError) {
      _hasShownError = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Message.showErrorSnackbar(
          context: context,
          message: state.errorMessage,
        );
      });
    }

    if (state is HomeStateConnection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Message.showInfoSnackbar(
          context: context,
          message: state.infoMessage,
        );
      });
    }

    if (state is HomeStateNewVisitSchedule) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Message.showInfoSnackbar(
          context: context,
          message: state.message,
        );
      });
    }

    if (state is HomeStateNewEvaluation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Message.showInfoSnackbar(
          context: context,
          message: state.message,
        );
      });
    }
  }
}
