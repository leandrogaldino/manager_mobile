import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    String? message,
  }) : _message = message;

  final String? _message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.threeArchedCircle(
              color: theme.colorScheme.primary,
              size: 50,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              _message ?? 'Carregando...',
              style: theme.textTheme.titleLarge!.copyWith(color: theme.colorScheme.primary),
            )
          ],
        ),
      ),
    );
  }
}
