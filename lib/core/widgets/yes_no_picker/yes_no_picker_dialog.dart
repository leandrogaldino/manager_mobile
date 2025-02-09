// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class YesNoPickerDialog extends StatelessWidget {
  const YesNoPickerDialog({
    super.key,
    required this.question,
  });
  final String question;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center(
        child: Text(
          'Confirmação',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      content: Text(
        question,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Sim"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Não"),
        ),
      ],
    );
  }
}
