import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/enums/source_types.dart';

class SignatureSectionWidget extends StatefulWidget {
  const SignatureSectionWidget({
    super.key,
    required this.evaluationController,
  });
  final EvaluationController evaluationController;
  @override
  State<SignatureSectionWidget> createState() => _SignatureSectionWidgetState();
}

class _SignatureSectionWidgetState extends State<SignatureSectionWidget> {
  @override
  Widget build(BuildContext context) {
    EvaluationController controller = widget.evaluationController;
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
              final signable = controller.evaluation!.compressor != null && controller.source != SourceTypes.fromSavedWithSign;
              if (signable) {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pushNamed(Routes.captureSignature);
              }
            },
            child: ListenableBuilder(
                listenable: controller,
                builder: (context, child) {
                  final cloudPath = controller.evaluation!.signatureCloudPath;
                  final localPath = controller.evaluation!.signatureLocalPath;
                  final hasSignature = cloudPath != null || localPath != null;

                  return Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                      ),
                      child: hasSignature
                          ? localPath != null
                              ? Image.file(
                                  File(localPath),
                                  fit: BoxFit.contain,
                                )
                              : Icon(
                                  Icons.cloud_download,
                                  color: Theme.of(context).colorScheme.primary.withAlpha(255),
                                  size: 38,
                                )
                          : Center(
                              child: Text(
                                'Toque para assinar',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ));
                }),
          ),
        ],
      )),
    );
  }
}
