import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/pages/evaluation/evaluation_page.dart';
import 'package:manager_mobile/pages/signature/signature_signature_page.dart';
import 'package:manager_mobile/pages/home/home_page.dart';
import 'package:manager_mobile/pages/login/login_page.dart';
import 'package:manager_mobile/core/app_theme.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/widgets/auth_state_listener_widget.dart';
import 'package:manager_mobile/core/widgets/loader_widget.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = AppTheme.appTextTheme;
    AppTheme appTheme = AppTheme(textTheme);
    AppController controller = GetIt.I<AppController>();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => AsyncStateBuilder(
        enableLog: true,
        customLoader: const LoaderWidget(),
        builder: (observer) => MaterialApp(
          title: 'Gerenciador',
          theme: appTheme.light(),
          darkTheme: appTheme.dark(),
          themeMode: controller.themeMode,
          home: const AuthStateListenerWidget(),
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            if (settings.name == Routes.evaluation) {
              final String? args = settings.arguments as String?;
              final instructions = args;
              return MaterialPageRoute(
                builder: (context) => EvaluationPage(
                  instructions: instructions,
                ),
              );
            }

            return null;
          },
          routes: {
            Routes.login: (context) => const LoginPage(),
            Routes.home: (context) => const HomePage(),
            Routes.evaluationSignature: (context) => const EvaluationSignaturePage(),
          },
        ),
      ),
    );
  }
}
