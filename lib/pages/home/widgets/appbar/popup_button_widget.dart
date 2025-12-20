import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/theme_switch_widget.dart';

class PopupButtonWidget extends StatelessWidget {
  const PopupButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Locator.get<LoginController>();

    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: FutureBuilder(
                future: loginController.currentLoggedUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Carregando...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ));
                  }
                  if (!snapshot.hasData) {
                    return Text('');
                  }
                  return Text(
                    snapshot.data!.shortName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => const ThemeSwitchWidget(),
              );
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              bool? answer = await YesNoPicker.pick(
                context: context,
                question: 'Deseja sair?',
              );

              if (answer == true && context.mounted) {
                Navigator.pop(context);
                await loginController.signOut();
              }
            },
          ),
        ),
      ],
    );
  }
}
