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
  SignatureController? _signatureController;
  late final EvaluationController _evaluationController;
  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    _signatureController?.dispose;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_signatureController != null) return;
    _signatureController = SignatureController(
      penStrokeWidth: 2,
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
                    controller: _signatureController!,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () => _signatureController!.undo(), child: Text('Desfazer')),
                    ElevatedButton(onPressed: () => _signatureController!.clear(), child: Text('Limpar')),
                    ElevatedButton(onPressed: () => _signatureController!.redo(), child: Text('Refazer')),
                    ElevatedButton(
                      onPressed: () async {
                        if (_signatureController!.isNotEmpty) {
                          var signatureBytes = await _signatureController!.toPngBytes();
                          if (signatureBytes != null) {
                            await _evaluationController.saveTempSignature(signatureBytes: signatureBytes);
                            await _evaluationController.updateImagesBytes();
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
