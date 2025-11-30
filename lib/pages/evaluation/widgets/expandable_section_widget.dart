import 'package:flutter/material.dart';

class ExpandableSectionWidget extends StatefulWidget {
  const ExpandableSectionWidget({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.onExpand, // <-- Novo parâmetro
  });

  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final VoidCallback? onExpand; // <-- Chamado quando a expansão é concluída

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
          title: widget.title,
          onExpansionChanged: (isExpanded) {
            if (isExpanded) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  // Verifica se o widget ainda está na árvore antes de rolar
                  widget.onExpand?.call();
                } // Chama o callback de rolagem
              });
            }
          },
          children: widget.children,
        ),
      ),
    );
  }
}
