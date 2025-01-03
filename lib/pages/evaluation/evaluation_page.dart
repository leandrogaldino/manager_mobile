import 'package:flutter/material.dart';
import 'package:manager_mobile/models/evaluation_model.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key, required this.evaluation});

  final EvaluationModel evaluation;

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
