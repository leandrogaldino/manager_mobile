import 'package:flutter/material.dart';

class InstructionsSectionWidget extends StatelessWidget {
  const InstructionsSectionWidget({
    super.key,
    required this.instructions,
  });
  final String instructions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(instructions),
      ),
    );
  }
}
