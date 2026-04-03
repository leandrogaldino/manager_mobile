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
  late final SignatureController _signatureController;
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();

    _evaluationController = Locator.get<EvaluationController>();

    _signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _signatureController.dispose(); // ✅ corrigido

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  Future<void> _onAccept() async {
    if (_signatureController.isEmpty) {
      Message.showInfoSnackbar(
        context: context,
        message: 'Assine antes de aceitar',
      );
      return;
    }

    final bytes = await _signatureController.toPngBytes();

    if (bytes != null) {
      await _evaluationController.saveTempSignature(
        signatureBytes: bytes,
      );
      await _evaluationController.updateImagesBytes();
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assinatura'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Signature(
                      controller: _signatureController,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
              ),
            ),

            /// Botões
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: _signatureController.undo,
                    child: const Text('Desfazer'),
                  ),
                  OutlinedButton(
                    onPressed: _signatureController.redo,
                    child: const Text('Refazer'),
                  ),
                  OutlinedButton(
                    onPressed: _signatureController.clear,
                    child: const Text('Limpar'),
                  ),
                  ElevatedButton(
                    onPressed: _onAccept,
                    child: const Text('Aceitar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
