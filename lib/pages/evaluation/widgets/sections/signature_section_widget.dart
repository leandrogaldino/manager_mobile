import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';

class SignatureSectionWidget extends StatefulWidget {
  const SignatureSectionWidget({super.key, required this.evaluation});

  final EvaluationModel evaluation;

  @override
  State<SignatureSectionWidget> createState() => _SignatureSectionWidgetState();
}

class _SignatureSectionWidgetState extends State<SignatureSectionWidget> {
  late final EvaluationController evaluationController;

  @override
  void initState() {
    super.initState();
    evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.evaluationSignature, arguments: [widget.evaluation]);
            FocusScope.of(context).unfocus();
          },
          child: ListenableBuilder(
              listenable: evaluationController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: evaluationController.signatureBytes == null ? Center(child: Text('Toque para assinar')) : Image.memory(evaluationController.signatureBytes!),
                );
              }),
        ),
      ],
    ));
  }
}
