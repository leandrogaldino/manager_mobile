import 'package:flutter/material.dart';

class ExpandableSectionWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final List<IconButton>? actionButtons;

  const ExpandableSectionWidget({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.actionButtons,
  });

  @override
  State<ExpandableSectionWidget> createState() => _ExpandableSectionWidgetState();
}

class _ExpandableSectionWidgetState extends State<ExpandableSectionWidget> {
  late bool isExpanded;
  final GlobalKey _expandableKey = GlobalKey(); // Usamos GlobalKey para referenciar o widget

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (widget.actionButtons != null && isExpanded)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.actionButtons!
                          .map((button) => Row(
                                children: [
                                  button,
                                  const SizedBox(width: 8), // Espaçamento entre os botões
                                ],
                              ))
                          .toList(),
                    ),
                ],
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).colorScheme.surface,
              ),
              onTap: () async {
                setState(() {
                  if (isExpanded) {
                    FocusScope.of(context).unfocus();
                  }
                  isExpanded = !isExpanded;
                });
                if (isExpanded) {
                  await Future.delayed(Duration(milliseconds: 300), () {
                    if (!context.mounted) return;
                    Scrollable.ensureVisible(
                      context,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                }
              },
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Offstage(
              offstage: !isExpanded,
              child: Padding(
                key: _expandableKey, // Usamos o GlobalKey aqui
                padding: const EdgeInsets.all(16.0),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
