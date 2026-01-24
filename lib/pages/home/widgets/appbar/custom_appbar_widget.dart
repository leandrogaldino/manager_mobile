import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/popup_button_widget.dart';
import 'package:manager_mobile/states/home_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Locator.get<HomeController>();

    return ListenableBuilder(
      listenable: homeController,
      builder: (context, _) {
        if (homeController.state is HomeStateLoading) {
          return const SizedBox.shrink();
        }
        return AppBar(
          leading: homeController.currentIndex == 0 ? const Icon(Icons.calendar_today) : const Icon(Icons.content_paste),
          title: Text(
            homeController.currentIndex == 0 ? 'Agendamentos' : 'Avaliações',
          ),
          centerTitle: true,
          elevation: 1,
          actions: [
            if (homeController.filter.showFilterButton)
              IconButton(
                onPressed: () {
                  homeController.filter.toggleFilterBar();
                },
                icon: Icon(
                  homeController.filter.filtering ? Icons.filter_alt : Icons.filter_alt_off,
                ),
              ),
            PopupButtonWidget(),
          ],
        );
      },
    );
  }

  @override
  final Size preferredSize;
}
