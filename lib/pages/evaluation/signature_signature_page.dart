// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_mobile/app.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/pages/home/widgets/appbar/custom_appbar_widget.dart';
import 'package:signature/signature.dart';

import 'package:manager_mobile/models/evaluation_model.dart';

class EvaluationSignaturePage extends StatefulWidget {
  const EvaluationSignaturePage({
    super.key,
    required this.evaluation,
  });

  final EvaluationModel evaluation;

  @override
  State<EvaluationSignaturePage> createState() => _EvaluationSignaturePageState();
}

class _EvaluationSignaturePageState extends State<EvaluationSignaturePage> {
  late final SignatureController signatureController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    signatureController.dispose;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    signatureController = SignatureController(
      penColor: Theme.of(context).colorScheme.onSecondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assinatura'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Signature(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                controller: signatureController,
              ),
            ),
          ),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => signatureController.undo(), child: Text('Desfazer')),
              ElevatedButton(onPressed: () => signatureController.clear(), child: Text('Limpar')),
              ElevatedButton(onPressed: () => signatureController.redo(), child: Text('Refazer')),
              ElevatedButton(
                  onPressed: () async {
                    if (signatureController.isNotEmpty) {
                      var bytes = await signatureController.;

                    } else {
                      if (!context.mounted) return;
                      Message.showInfoSnackbar(context: context, message: 'Assine antes de aceitar');
                    }
                  },
                  child: Text('Aceitar')),
            ],
          )
        ],
      )),
    );
  }
}
