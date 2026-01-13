import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/popup_button_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Locator.get<HomeController>();
    

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
            listenable: homeController,
            builder: (context, child) {
              return homeController.filter.showFilterButton ? IconButton(
                onPressed: () {
                  homeController.filter.toggleFilterBar();
                },
                icon: Icon(homeController.filter.filtering ? Icons.filter_alt : Icons.filter_alt_off),
              ) : SizedBox.shrink();
            }),
        PopupButtonWidget(),
      ],
    );
  }

  @override
  final Size preferredSize;
}
