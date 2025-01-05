import 'dart:developer';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/services/evaluation_service.dart';

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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                //await Locator.get<AppController>().syncronize().asyncLoader(customLoader: Loader(message: 'Sincronizando Dados'));
                //await Locator.get<LocalDatabase>().delete('evaluation');
                //await Locator.get<LocalDatabase>().delete('evaluationphoto');
                //await Locator.get<LocalDatabase>().delete('evaluationinfo');
                //await Locator.get<LocalDatabase>().delete('evaluationtechnician');
                //await Locator.get<LocalDatabase>().delete('evaluationcoalescent');
                //final lastSyncResult = await Locator.get<LocalDatabase>().query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsync']);
                //int lastSync = int.parse(lastSyncResult[0]['value'].toString());
                //await Locator.get<EvaluationService>().syncronize(0);

                var evaluations = await Locator.get<EvaluationService>().getAll();

                log(evaluations.toString());
              },
              child: Text('Run'),
            ),
          ],
        ),
      ),
    );
  }
}
