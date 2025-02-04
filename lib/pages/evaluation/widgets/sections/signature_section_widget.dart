import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:signature/signature.dart';

class SignatureSectionWidget extends StatefulWidget {
  const SignatureSectionWidget({super.key, required this.evaluation});

  final EvaluationModel evaluation;

  @override
  State<SignatureSectionWidget> createState() => _SignatureSectionWidgetState();
}

class _SignatureSectionWidgetState extends State<SignatureSectionWidget> {
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
          },
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget.evaluation.signaturePath == null
                ? Center(child: Text('Toque para assinar'))
                : Image.file(
                    File(widget.evaluation.signaturePath!),
                  ),
          ),
        ),
      ],
    ));
  }
}
