import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/popup_button_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onFilterToggle;

  CustomAppBar({required this.onFilterToggle, super.key}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final loginController = Locator.get<LoginController>();
    final homeController = Locator.get<HomeController>();
    return AppBar(
      leading: IconButton(
        onPressed: (() async {
          await loginController.signOut().asyncLoader();
        }),
        icon: Icon(Icons.edit_note_outlined),
      ),
      title: Text('Agendamentos'),
      centerTitle: true,
      elevation: 1,
      actions: [
        ListenableBuilder(
            listenable: homeController,
            builder: (context, child) {
              return IconButton(
                onPressed: onFilterToggle,
                icon: Icon(homeController.filtering ? Icons.filter_alt_off : Icons.filter_alt),
              );
            }),
        PopupButton(loginController: loginController),
      ],
    );
  }

  @override
  final Size preferredSize;
}
