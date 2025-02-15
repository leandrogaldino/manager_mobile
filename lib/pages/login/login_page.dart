import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/pages/login/widgets/app_title_widget.dart';
import 'package:manager_mobile/core/widgets/loader_widget.dart';
import 'package:manager_mobile/states/login_state.dart';
import 'package:validatorless/validatorless.dart';

//TODO: deslogar, desligar a internet, esperar dar erro, e depois clicar para mostrar e esconder senha
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailEC;
  late final TextEditingController passwordEC;
  late final LoginController loginController;
  late final AppController appController;
  bool obscurePassword = true;
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailEC = TextEditingController();
    passwordEC = TextEditingController();
    loginController = GetIt.I<LoginController>();
    appController = GetIt.I<AppController>();
  }

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
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
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('Usuário obrigatório'),
                        ]),
                        decoration: const InputDecoration(labelText: 'Usuário'),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        obscureText: obscurePassword,
                        controller: passwordEC,
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
                        listenable: loginController,
                        builder: (context, child) {
                          if (loginController.state is LoginStateError) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              final errorState = loginController.state as LoginStateError;
                              Message.showErrorSnackbar(context: context, message: errorState.message);
                            });
                          }

                          return SizedBox(
                            width: screenSize.width * 0.5,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () async {
                                final valid = formKey.currentState?.validate() ?? false;
                                if (valid) {
                                  await loginController.singIn('${emailEC.text}@manager.com', passwordEC.text).asyncLoader(
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
