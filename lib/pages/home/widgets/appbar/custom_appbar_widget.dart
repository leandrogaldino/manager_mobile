import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/filter_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/popup_button_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Locator.get<HomeController>();
    final FilterController filterController = Locator.get<FilterController>();

    return AppBar(
      leading: ListenableBuilder(
        listenable: homeController,
        builder: (context, child) {
          return homeController.currentIndex == 0 ? Icon(Icons.calendar_today) : Icon(Icons.content_paste);
        },
      ),
      title: ListenableBuilder(
        listenable: homeController,
        builder: (context, child) {
          return homeController.currentIndex == 0 ? Text('Agendamentos') : Text('Avaliações');
        },
      ),
      centerTitle: true,
      elevation: 1,
      actions: [
        ListenableBuilder(
            listenable: filterController,
            builder: (context, child) {
              return IconButton(
                onPressed: () {
                  filterController.toggleFilterBarVisible();
                },
                icon: Icon(filterController.filtering ? Icons.filter_alt : Icons.filter_alt_off),
              );
            }),
        PopupButtonWidget(),
      ],
    );
  }

  @override
  final Size preferredSize;
}
