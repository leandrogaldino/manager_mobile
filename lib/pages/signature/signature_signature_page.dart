import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:signature/signature.dart';

class EvaluationSignaturePage extends StatefulWidget {
  const EvaluationSignaturePage({super.key});

  @override
  State<EvaluationSignaturePage> createState() => _EvaluationSignaturePageState();
}

class _EvaluationSignaturePageState extends State<EvaluationSignaturePage> {
  SignatureController? signatureController;
  late final EvaluationController evaluationController;
  @override
  void initState() {
    super.initState();
    evaluationController = Locator.get<EvaluationController>();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    signatureController?.dispose;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (signatureController != null) return;
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
      body: SingleChildScrollView(
        child: Center(
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
                    controller: signatureController!,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () => signatureController!.undo(), child: Text('Desfazer')),
                    ElevatedButton(onPressed: () => signatureController!.clear(), child: Text('Limpar')),
                    ElevatedButton(onPressed: () => signatureController!.redo(), child: Text('Refazer')),
                    ElevatedButton(
                      onPressed: () async {
                        if (signatureController!.isNotEmpty) {
                          var signatureBytes = await signatureController!.toPngBytes();
                          if (signatureBytes != null) {
                            await evaluationController.saveSignature(signatureBytes: signatureBytes, asTemporary: true);
                          }
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        } else {
                          Message.showInfoSnackbar(context: context, message: 'Assine antes de aceitar');
                        }
                      },
                      child: Text('Aceitar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
