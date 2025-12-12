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

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppTitle(),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Campo EMAIL
                          TextFormField(
                            controller: _emailEC,
                            validator: Validatorless.required('Usuário obrigatório'),
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              labelText: 'Usuário',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordEC,
                            obscureText: obscurePassword,
                            validator: Validatorless.required('Senha obrigatória'),
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() {
                                  obscurePassword = !obscurePassword;
                                }),
                                icon: Icon(
                                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          ListenableBuilder(
                            listenable: _loginController,
                            builder: (context, _) {
                              final state = _loginController.state;

                              if (state is LoginStateError && !_hasShownError) {
                                _hasShownError = true;
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Message.showErrorSnackbar(
                                    context: context,
                                    message: state.message,
                                  );
                                });
                              }
                              if (state is LoginStateSuccess) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pushReplacementNamed(context, Routes.home);
                                });
                              }
                              final loading = state is LoginStateLoading;
                              return SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: loading
                                      ? null
                                      : () async {
                                          if (!(_formKey.currentState?.validate() ?? false)) {
                                            return;
                                          }
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
                                          'Entrar',
                                          style: theme.textTheme.titleMedium!.copyWith(
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
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
