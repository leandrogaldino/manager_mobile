import 'package:flutter/material.dart';

class ExpandableSectionWidget extends StatefulWidget {
  const ExpandableSectionWidget({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.onExpand,
  });

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final VoidCallback? onExpand;

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
          dividerColor: Theme.of(context).colorScheme.outline,
        ),
        child: ExpansionTile(
          minTileHeight: 0,
          maintainState: true,
          initiallyExpanded: widget.initiallyExpanded,
          collapsedIconColor: Theme.of(context).colorScheme.surface,
          collapsedBackgroundColor: Theme.of(context).colorScheme.secondary,
          collapsedTextColor: Theme.of(context).colorScheme.surface,
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onExpansionChanged: (isExpanded) {
            if (isExpanded) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) widget.onExpand?.call();
              });
            }
          },
          children: widget.children,
        ),
      ),
    );
  }
}
