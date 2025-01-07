import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/popup_button_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final loginController = Locator.get<LoginController>();
    return AppBar(
      leading: IconButton(
        onPressed: (() async {
          await loginController.signOut().asyncLoader();
        }),
        icon: Icon(Icons.edit_note_outlined),
      ),
      title: Text('Titulo'),
      centerTitle: true,
      elevation: 1,
      actions: [
        PopupButton(loginController: loginController),
      ],
    );
  }

  @override
  final Size preferredSize;
}
