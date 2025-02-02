import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';

class ThemeSwitchWidget extends StatefulWidget {
  const ThemeSwitchWidget({super.key});

  @override
  State<ThemeSwitchWidget> createState() => _ThemeSwitchWidgetState();
}

class _ThemeSwitchWidgetState extends State<ThemeSwitchWidget> {
  late final AppController appController;

  @override
  void initState() {
    super.initState();
    appController = GetIt.I<AppController>();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListenableBuilder(
        listenable: appController,
        builder: (context, child) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Escolha um tema',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  AnimatedToggleSwitch.rolling(
                    values: const ['Claro', 'Escuro', 'Sistema'],
                    current: appController.getThemeModeName(appController.themeMode),
                    onChanged: (value) async => await appController.changeTheme(appController.getThemeMode(value)),
                    iconBuilder: (a, b) {
                      return Icon(
                        switch (a) {
                          'Claro' => Icons.light_mode,
                          'Escuro' => Icons.dark_mode,
                          _ => Icons.android,
                        },
                        size: 40,
                      );
                    },
                    style: ToggleStyle(indicatorColor: theme.colorScheme.tertiary),
                    spacing: 30,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appController.getThemeModeName(appController.themeMode),
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
