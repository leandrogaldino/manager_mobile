import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/util/message.dart';
import 'package:manager_mobile/pages/login/widgets/app_title_widget.dart';
import 'package:manager_mobile/core/widgets/loader.dart';
import 'package:manager_mobile/states/login_state.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final controller = GetIt.I<LoginController>();
  final appController = GetIt.I<AppController>();

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
                      ValueListenableBuilder<bool>(
                        valueListenable: controller.obscurePassword,
                        builder: (_, obscurePassword, __) {
                          return TextFormField(
                            obscureText: obscurePassword,
                            controller: passwordEC,
                            validator: Validatorless.required('Senha obrigatória'),
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              suffixIcon: IconButton(
                                onPressed: controller.toggleObscurePassword,
                                icon: Icon(
                                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                                ),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ValueListenableBuilder<LoginState>(
                        valueListenable: controller.state,
                        builder: (context, state, child) {
                          // Exibir erro em uma SnackBar
                          if (state is LoginStateError) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Message.showErrorSnackbar(context: context, message: state.message);
                            });
                          }

                          return SizedBox(
                            width: screenSize.width * 0.5,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () async {
                                final valid = formKey.currentState?.validate() ?? false;
                                if (valid) {
                                  await controller.singIn('${emailEC.text}@manager.com', passwordEC.text).asyncLoader(
                                        customLoader: const Loader(message: 'Entrando'),
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
