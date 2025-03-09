import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/enums/source_types.dart';

class SignatureSectionWidget extends StatefulWidget {
  const SignatureSectionWidget({super.key});

  @override
  State<SignatureSectionWidget> createState() => _SignatureSectionWidgetState();
}

class _SignatureSectionWidgetState extends State<SignatureSectionWidget> {
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (_evaluationController.source != SourceTypes.fromSaved) {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.of(context).pushNamed(Routes.captureSignature);
              } else {
                null;
              }
            },
            child: ListenableBuilder(
                listenable: _evaluationController,
                builder: (context, child) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    child: _evaluationController.signatureBytes == null
                        ? Center(
                            child: Text(
                              'Toque para assinar',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          )
                        : Image.memory(_evaluationController.signatureBytes!),
                  );
                }),
          ),
        ],
      )),
    );
  }
}
