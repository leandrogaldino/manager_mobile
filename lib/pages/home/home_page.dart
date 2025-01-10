import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/custom_appbar_widget.dart';
import 'package:manager_mobile/pages/home/widgets/filterbar/filterbar_widget.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 5,
          children: [
            ListenableBuilder(
              listenable: homeController,
              builder: (context, child) {
                if (!homeController.filterBarVisible) FocusScope.of(context).unfocus();
                return ClipRect(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: homeController.filterBarVisible ? 150 : 0,
                    child: SingleChildScrollView(
                      child: FilterBar(),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
              ),
            ),
          ],
        ),
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
      // await controller.getStories().asyncLoader();
    });
    super.initState();
  }

  @override
  void dispose() {
    //_textController.dispose();
    super.dispose();
  }
}
