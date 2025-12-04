import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/theme_switch_widget.dart';

class PopupButtonWidget extends StatefulWidget {
  const PopupButtonWidget({super.key});

  @override
  State<PopupButtonWidget> createState() => _PopupButtonWidgetState();
}

class _PopupButtonWidgetState extends State<PopupButtonWidget> {
  late final LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = Locator.get<LoginController>();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text('EDNALDO NUNES', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
              bool? answer = await YesNoPicker.pick(context: context, question: 'Deseja sair?');
              if (answer == true) {
                if (!context.mounted) return;
                Navigator.pop(context);
                await _loginController.signOut();
              }
            },
          ),
        ),
      ],
    );
  }
}
