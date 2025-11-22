import 'package:flutter/material.dart';

class ReplacedProductSectionWidget extends StatefulWidget {
  const ReplacedProductSectionWidget({super.key});

  @override
  State<ReplacedProductSectionWidget> createState() => _ReplacedProductSectionWidgetState();
}

class _ReplacedProductSectionWidgetState extends State<ReplacedProductSectionWidget> {
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
