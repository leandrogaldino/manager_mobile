import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/pages/home/home_page.dart';
import 'package:manager_mobile/pages/login/login_page.dart';
import 'package:manager_mobile/core/widgets/loader_widget.dart';

class AuthStateListenerWidget extends StatelessWidget {
  const AuthStateListenerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Enquanto o stream está carregando pela primeira vez
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderWidget(message: 'Entrando');
        }

        final user = snapshot.data;

        // Usuário logado
        if (user != null) {
          return const HomePage();
        }

        // Usuário deslogado
        return const LoginPage();
      },
    );
  }
}