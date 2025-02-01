import 'package:flutter/material.dart';

class StructionsSectionWidget extends StatelessWidget {
  const StructionsSectionWidget({
    super.key,
    required this.instructions,
  });
  final String instructions;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(instructions),
    );
  }
}
