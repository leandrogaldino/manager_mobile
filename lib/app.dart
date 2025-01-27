import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/evaluation/evaluation_page.dart';
import 'package:manager_mobile/pages/home/home_page.dart';
import 'package:manager_mobile/pages/login/login_page.dart';
import 'package:manager_mobile/core/app_theme.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/widgets/auth_state_listener.dart';
import 'package:manager_mobile/core/widgets/loader.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = AppTheme.appTextTheme;
    AppTheme appTheme = AppTheme(textTheme);
    AppController controller = GetIt.I<AppController>();

    return ValueListenableBuilder(
      valueListenable: controller.themeMode,
      builder: (context, themeMode, child) => AsyncStateBuilder(
        enableLog: true,
        customLoader: const Loader(),
        builder: (observer) => MaterialApp(
          title: 'Gerenciador',
          theme: appTheme.light(),
          darkTheme: appTheme.dark(),
          themeMode: themeMode,
          home: const AuthStateListener(),
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            if (settings.name == Routes.evaluation) {
              final evaluation = settings.arguments as EvaluationModel;
              return MaterialPageRoute(
                builder: (context) => EvaluationPage(evaluation: evaluation),
              );
            }
            return null;
          },
          routes: {
            Routes.login: (context) => const LoginPage(),
            Routes.home: (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}
