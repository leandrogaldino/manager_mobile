import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      spacing: 5,
      children: [
        Divider(),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Filtrar",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.onSecondary,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 15,
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: theme.colorScheme.onSecondary,
                  ),
                  Text(
                    'Data',
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
