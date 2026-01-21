import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/core/util/connection_notifier.dart';
import 'package:manager_mobile/core/helper/string_helper.dart';
import 'package:manager_mobile/pages/evaluation/evaluation_page.dart';
import 'package:manager_mobile/pages/photos/photos_page.dart';
import 'package:manager_mobile/pages/signature/signature_signature_page.dart';
import 'package:manager_mobile/pages/home/home_page.dart';
import 'package:manager_mobile/pages/login/login_page.dart';
import 'package:manager_mobile/core/app_theme.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/widgets/auth_state_listener_widget.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = AppTheme.appTextTheme;
    AppTheme appTheme = AppTheme(textTheme);
    AppController appController = GetIt.I<AppController>();
    return ConnectionNotifier(
      notifier: ValueNotifier<bool>(true),
      child: ListenableBuilder(
        listenable: appController,
        builder: (context, child) => MaterialApp(
          title: 'Gerenciador',
          theme: appTheme.light(),
          darkTheme: appTheme.dark(),
          themeMode: appController.themeMode,
          home: const AuthStateListenerWidget(),
          onGenerateRoute: (settings) {
            if (settings.name == Routes.takePhoto) {
              return MaterialPageRoute<File?>(
                builder: (context) => CameraCamera(
                  enableZoom: false,
                  cameraSide: CameraSide.front,
                  onFile: (file) async {
                    final dir = file.parent;
                    final fileName = StringHelper.getUniqueString(suffix: '.jpg');
                    final newPath = '${dir.path}/$fileName';
                    final renamed = await file.rename(newPath);
                    if (context.mounted) Navigator.pop(context, renamed);
                  },
                ),
              );
            }
            return null;
          },
          routes: {
            Routes.login: (context) => const LoginPage(),
            Routes.home: (context) => const HomePage(),
            Routes.evaluation: (context) => EvaluationPage(),
            Routes.captureSignature: (context) => const EvaluationSignaturePage(),
            Routes.viewPhoto: (context) => const PhotosPage(),
          },
          locale: Locale('pt', 'BR'),
          supportedLocales: [Locale('pt', 'BR')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
