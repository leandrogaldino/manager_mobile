import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/custom_appbar_widget.dart';

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
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {},
              child: Text('Run'),
            ),
          ],
        ),
      ),
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
