import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/pages/login/widgets/app_title_widget.dart';
import 'package:manager_mobile/core/widgets/loader_widget.dart';
import 'package:manager_mobile/states/login_state.dart';
import 'package:validatorless/validatorless.dart';

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
  bool _hasShownError = false;

  bool obscurePassword = true;
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
    final screenSize = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

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
                      TextFormField(
                        controller: _emailEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('Usuário obrigatório'),
                        ]),
                        decoration: const InputDecoration(labelText: 'Usuário'),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        obscureText: obscurePassword,
                        controller: _passwordEC,
                        validator: Validatorless.required('Senha obrigatória'),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: IconButton(
                            onPressed: () => setState(() {
                              obscurePassword = !obscurePassword;
                            }),
                            icon: Icon(
                              obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ListenableBuilder(
                        listenable: _loginController,
                        builder: (context, child) {
                          final state = _loginController.state;
                          if (state is LoginStateError && !_hasShownError) {
                            _hasShownError = true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Message.showErrorSnackbar(context: context, message: state.message);
                            });
                          }

                          return SizedBox(
                            width: screenSize.width * 0.5,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () async {
                                final valid = _formKey.currentState?.validate() ?? false;
                                if (valid) {
                                  _hasShownError = false;
                                  await _loginController.singIn('${_emailEC.text}@manager.com', _passwordEC.text).asyncLoader(
                                        customLoader: const LoaderWidget(message: 'Entrando'),
                                      );
                                }
                              },
                              child: Text(
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
