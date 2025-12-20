import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/pages/home/home_page.dart';
import 'package:manager_mobile/pages/login/login_page.dart';

class AuthStateListenerWidget extends StatefulWidget {
  const AuthStateListenerWidget({super.key});

  @override
  State<AuthStateListenerWidget> createState() =>
      _AuthStateListenerWidgetState();
}

class _AuthStateListenerWidgetState extends State<AuthStateListenerWidget> {
  Future<void>? _userFuture;
  late final StreamSubscription<User?> _authSubscription;

  late final RemoteDatabase _remoteDatabase;
  late final AppPreferences _appPreferences;

  @override
  void initState() {
    super.initState();

    _remoteDatabase = Locator.get<RemoteDatabase>();
    _appPreferences = Locator.get<AppPreferences>();

    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  void _onAuthChanged(User? user) {
    if (!mounted) return;

    setState(() {
      if (user == null) {
        _userFuture = _unloadUser();
      } else {
        _userFuture = _loadUserData(user.uid);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_userFuture == null) {
      return const LoginPage();
    }

    return FutureBuilder<void>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = FirebaseAuth.instance.currentUser;
        return user == null ? const LoginPage() : const HomePage();
      },
    );
  }


  Future<void> _loadUserData(String userId) async {
    final result = await _remoteDatabase.get(
      collection: 'users',
      filters: [
        RemoteDatabaseFilter(
          field: 'userid',
          operator: FilterOperator.isEqualTo,
          value: userId,
        ),
      ],
    );

    final technicianId =
        result.isEmpty ? 0 : int.parse(result.first['personid'].toString());

    await _appPreferences.setLoggedTechnicianId(technicianId);
  }

  Future<void> _unloadUser() async {
    await _appPreferences.setLoggedTechnicianId(0);
  }
}
