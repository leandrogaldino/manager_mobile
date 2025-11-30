import 'package:flutter/material.dart';

class PerformedServiceSectionWidget extends StatefulWidget {
  const PerformedServiceSectionWidget({super.key});

  @override
  State<PerformedServiceSectionWidget> createState() => _PerformedServiceSectionWidgetState();
}

class _PerformedServiceSectionWidgetState extends State<PerformedServiceSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Container(
          color: Colors.red,
        ));
  }
}
