import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
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
              final List<Object> args = settings.arguments as List<Object>;
              final evaluation = args[0] as EvaluationModel;
              final source = args[1] as EvaluationSource;
              final instructions = (args.length > 2 && args[2] is String) ? args[2] as String : null;
              return MaterialPageRoute(
                builder: (context) => EvaluationPage(
                  evaluation: evaluation,
                  source: source,
                  instructions: instructions,
                ),
              );
            }
            if (settings.name == Routes.evaluationSignature) {
              final List<Object> args = settings.arguments as List<Object>;
              final evaluation = args[0] as EvaluationModel;

              return MaterialPageRoute(
                builder: (context) => EvaluationSignaturePage(
                  evaluation: evaluation,
                ),
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
