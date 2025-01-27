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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderWidget(message: 'Entrando');
        } else if (snapshot.hasData && snapshot.data != null) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
