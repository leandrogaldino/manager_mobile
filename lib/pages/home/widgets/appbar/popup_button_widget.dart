// app_popup_menu.dart
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/widgets/loader.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/theme_switch_widget.dart';

class PopupButton extends StatelessWidget {
  final LoginController loginController;

  const PopupButton({super.key, required this.loginController});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return const ThemeSwitch();
                },
              );
              const ThemeSwitch();
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              Navigator.pop(context);
              await loginController.signOut().asyncLoader(
                    customLoader: const Loader(message: 'Saindo'),
                  );
            },
          ),
        ),
      ],
    );
  }
}
