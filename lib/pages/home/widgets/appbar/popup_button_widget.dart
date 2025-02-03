import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/loader_widget.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/theme_switch_widget.dart';

class PopupButtonWidget extends StatefulWidget {
  const PopupButtonWidget({super.key});

  @override
  State<PopupButtonWidget> createState() => _PopupButtonWidgetState();
}

class _PopupButtonWidgetState extends State<PopupButtonWidget> {
  late final LoginController loginController;

  @override
  void initState() {
    super.initState();
    loginController = Locator.get<LoginController>();
  }

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
                  return const ThemeSwitchWidget();
                },
              );
              const ThemeSwitchWidget();
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
                    customLoader: const LoaderWidget(message: 'Saindo'),
                  );
            },
          ),
        ),
      ],
    );
  }
}
