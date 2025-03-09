import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/core/widgets/loader_widget.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/theme_switch_widget.dart';

class PopupButtonWidget extends StatefulWidget {
  const PopupButtonWidget({super.key});

  @override
  State<PopupButtonWidget> createState() => _PopupButtonWidgetState();
}

class _PopupButtonWidgetState extends State<PopupButtonWidget> {
  late final LoginController _loginController;
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _loginController = Locator.get<LoginController>();
    _evaluationController = Locator.get<EvaluationController>();
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
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Limpar'),
            onTap: () async {
              Navigator.pop(context);
              bool? isYes = await YesNoPicker.pick(context: context, question: 'Avaliações com mais de 4 meses serão excluídas permanentemente deste dispositivo. Deseja continuar?') ?? false;
              if (isYes) {
                int deleted = await _evaluationController.clean();
                String deletedMessage = '';
                deleted > 0 ? deletedMessage = ', $deleted avaliações excluídas' : deletedMessage = ', nenhuma avaliação excluída';
                if (!context.mounted) {
                  return;
                }
                Message.showInfoSnackbar(context: context, message: 'Limpeza concluída$deletedMessage.');
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              Navigator.pop(context);
              await _loginController.signOut().asyncLoader(
                    customLoader: const LoaderWidget(message: 'Saindo'),
                  );
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Resetar LocalDB'),
            onTap: () async {
              Navigator.pop(context);

              var db = Locator.get<LocalDatabase>();
              await db.delete('schedule');
              await db.delete('evaluation');
            },
          ),
        ),
      ],
    );
  }
}
