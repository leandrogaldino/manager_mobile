import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Image.asset(
            'assets/images/app_icon.png',
          ),
        ),
        Text('Gerenciador', style: theme.textTheme.displayMedium!.copyWith(color: theme.colorScheme.primary)),
      ],
    );
  }
}
