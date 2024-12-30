import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/services/coalescent_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (() async {
              var c = GetIt.I<LoginController>();
              await c.signOut().asyncLoader();
            }),
            icon: Icon(Icons.logout)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final service = GetIt.I<CoalescentService>();
            final data = await service.syncronize();
            print(data);
          },
          child: Text('Run'),
        ),
      ),
    );
  }
}
