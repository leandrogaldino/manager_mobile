// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ExpandableSectionWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final IconButton? action;

  const ExpandableSectionWidget({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.action,
  });

  @override
  State<ExpandableSectionWidget> createState() => _ExpandableSectionWidgetState();
}

class _ExpandableSectionWidgetState extends State<ExpandableSectionWidget> {
  late bool isExpanded;

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
        color: Colors.white,
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Offstage(
                      offstage: widget.action == null,
                      child: Offstage(
                        offstage: !isExpanded,
                        child: widget.action,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    FocusScope.of(context).unfocus();
                  }
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Offstage(
              offstage: !isExpanded,
              child: Padding(
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
