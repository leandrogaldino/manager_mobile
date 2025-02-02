import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/core/app_preferences.dart';

class ThemeSwitchWidget extends StatelessWidget {
  const ThemeSwitchWidget({super.key});

  IconData iconDataByValue(String? value) => switch (value) {
        'Claro' => Icons.light_mode,
        'Escuro' => Icons.dark_mode,
        _ => Icons.android,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = GetIt.I<AppController>();
    final appPreferences = GetIt.I<AppPreferences>();
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
                        iconDataByValue(a),
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
