import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        color: Colors.transparent,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 50,
          children: [
            Text(
              'Sincronização em andamento',
              style: theme.textTheme.titleLarge!.copyWith(color: theme.colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            Lottie.asset(
              'assets/json/sync_animation.json',
              fit: BoxFit.fill,
              repeat: true,
            ),
            Text(
              'Mantenha o aplicativo aberto nesta tela e garanta uma conexão com a internet ativa.',
              style: theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.primary),
              textAlign: TextAlign.center,
            ),
          ],
        )),
      ),
    );
  }
}
