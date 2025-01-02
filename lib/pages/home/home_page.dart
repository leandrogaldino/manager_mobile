import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
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
            final rep = GetIt.I<CompressorRepository>();
            final data = await rep.syncronize();
            print(data);
            var all = await rep.getAll();
            print(all);
          },
          child: Text('Run'),
        ),
      ),
    );
  }
}
