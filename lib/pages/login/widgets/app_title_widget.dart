import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Text(
          'Gerenciador',
          style: theme.textTheme.displayMedium?.copyWith(
            fontFamily: 'DancingScript',
          ),
        ),
        Icon(
          Icons.phone_android,
          size: 48,
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }
}
