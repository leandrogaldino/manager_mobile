import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/pages/login/widgets/app_title_widget.dart';
import 'package:manager_mobile/states/login_state.dart';
import 'package:validatorless/validatorless.dart';
import 'package:manager_mobile/core/constants/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailEC;
  late final TextEditingController _passwordEC;
  late final LoginController _loginController;

  bool obscurePassword = true;
  bool _hasShownError = false;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _emailEC = TextEditingController();
    _passwordEC = TextEditingController();
    _loginController = GetIt.I<LoginController>();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppTitle(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // EMAIL
                      TextFormField(
                        controller: _emailEC,
                        validator: Validatorless.required('Usuário obrigatório'),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(labelText: 'Usuário'),
                      ),

                      const SizedBox(height: 18),

                      // SENHA
                      TextFormField(
                        controller: _passwordEC,
                        obscureText: obscurePassword,
                        validator: Validatorless.required('Senha obrigatória'),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscurePassword = !obscurePassword),
                            icon: Icon(
                              obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // BOTÃO COM ESTADO
                      ListenableBuilder(
                        listenable: _loginController,
                        builder: (context, _) {
                          final state = _loginController.state;

                          // ---- ERRO ----
                          if (state is LoginStateError && !_hasShownError) {
                            _hasShownError = true;

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Message.showErrorSnackbar(
                                context: context,
                                message: state.message,
                              );
                            });
                          }

                          // ---- SUCESSO ----
                          if (state is LoginStateSuccess) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushReplacementNamed(context, Routes.home);
                            });
                          }

                          final loading = state is LoginStateLoading;

                          return SizedBox(
                            width: screenSize.width * 0.5,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () async {
                                      final valid = _formKey.currentState?.validate() ?? false;
                                      if (!valid) return;

                                      _hasShownError = false;

                                      await _loginController.signIn(
                                        '${_emailEC.text}@manager.com',
                                        _passwordEC.text,
                                      );
                                    },
                              child: loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(
                                      'Login',
                                      style: theme.textTheme.titleLarge!.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
