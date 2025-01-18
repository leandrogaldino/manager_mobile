import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/custom_appbar_widget.dart';
import 'package:manager_mobile/pages/home/widgets/filterbar/filterbar_widget.dart';
import 'package:manager_mobile/pages/home/widgets/schedule/schedule_list_widget.dart';
import 'package:manager_mobile/states/home_state.dart';

//https://www.treinaweb.com.br/blog/criando-um-bottomnavigationbar-com-flutter?utm_source=&utm_medium=&utm_campaign=&utm_content=&gad_source=1&gclid=CjwKCAiAhP67BhAVEiwA2E_9g2_De7Y7S6geg0lLuAT71c6GBC8v-hqeCRxY2DAElcYJ9x7SWGbeDRoCBpUQAvD_BwE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appController = Locator.get<AppController>();
  final homeController = Locator.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onFilterToggle: homeController.toggleFilterBarVisibility,
      ),
      body: ListenableBuilder(
        listenable: homeController,
        builder: (context, child) {
          final state = homeController.state;
          if (!homeController.filterBarVisible) {
            FocusScope.of(context).unfocus();
          }
          if (state is HomeStateError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Message.showErrorSnackbar(context: context, message: state.errorMessage);
            });
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 5,
              children: [
                ClipRect(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: homeController.filterBarVisible ? 150 : 0,
                    child: SingleChildScrollView(
                      child: FilterBar(),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final result = await appController.syncronize();
                      _showSyncResultSnackbar(result);
                    },
                    child: ScheduleListWidget(schedules: homeController.schedules),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(onTap: (index) {}, items: [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Agendamentos"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: "Avaliações"),
      ]),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await appController.syncronize().asyncLoader();
      await homeController.fetchData().asyncLoader();
    });
    super.initState();
  }

  @override
  void dispose() {
    //_textController.dispose();
    super.dispose();
  }

  void _showSyncResultSnackbar(SyncronizeResultModel result) {
    String message = '';

    if (result.uploaded > 0) {
      message += result.uploaded == 1 ? 'Enviado: ${result.uploaded}' : 'Enviados: ${result.uploaded}';
    }

    if (result.downloaded > 0) {
      if (message.isNotEmpty) message += ' ';
      message += result.downloaded == 1 ? 'Baixado: ${result.downloaded}' : 'Baixados: ${result.downloaded}';
    }

    if (result.downloaded + result.uploaded > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Message.showSuccessSnackbar(context: context, message: message);
      });
    }
  }
}
