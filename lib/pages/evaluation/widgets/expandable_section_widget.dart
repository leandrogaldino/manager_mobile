import 'package:flutter/material.dart';

class ExpandableSectionWidget extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const ExpandableSectionWidget({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableSectionWidget> createState() => _ExpandableSectionWidgetState();
}

class _ExpandableSectionWidgetState extends State<ExpandableSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Theme.of(context).colorScheme.primary,
        ),
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          collapsedBackgroundColor: Theme.of(context).colorScheme.primary,
          collapsedTextColor: Theme.of(context).colorScheme.surface,
          title: widget.title,
          children: widget.children,
        ),
      ),
    );
  }
}
