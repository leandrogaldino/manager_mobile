import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/controllers/technician_controller.dart';
import 'package:manager_mobile/core/helper/technician_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/loader_widget.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/theme_switch_widget.dart';

class PopupButtonWidget extends StatelessWidget {
  const PopupButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Locator.get<LoginController>();
    final TechnicianController technicianController = Locator.get<TechnicianController>();
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
            leading: const Icon(Icons.build),
            title: const Text('Trocar Técnico'),
            onTap: () async {
              if (!context.mounted) return;
              Navigator.pop(context);

              var person = await TechnicianPicker.pick(
                context: context,
              );

              if (person != null) {
                await technicianController.setLoggedTechnicianId(person.id);
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Zerar Técnico'),
            onTap: () async {
              Navigator.pop(context);
              await technicianController.setLoggedTechnicianId(0);
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
