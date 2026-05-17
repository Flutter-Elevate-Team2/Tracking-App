import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/email_field.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/login_submit_button.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/password_field.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/remember_me_row.dart';
import 'package:tracking_app/core/app_router/app_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  /// Button is enabled only when both fields have text typed in them.
  bool get _isFormValid =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: BlocBuilder<LoginViewModel, LoginState>(
        builder: (context, state) {
          return Column(
            children: [
              EmailField(controller: _emailController, onChanged: () {}),
              PasswordField(controller: _passwordController, onChanged: () {}),
              RememberMeRow(
                rememberMe: state.isRememberMe,
                onChanged: (value) {
                  viewModel.doIntent(ToggleRememberMeEvent());
                },
                onForgotPassword: () {
                  context.pushNamed(Routes.forgetPasswordName);
                },
              ),
              const SizedBox(height: 16),
              ListenableBuilder(
                listenable: Listenable.merge([
                  _emailController,
                  _passwordController,
                ]),
                builder: (context, child) {
                  return LoginSubmitButton(
                    isLoading: state.loginState?.isLoading == true,
                    enabled: _isFormValid,
                    onPressed: () {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.always;
                      });
                      if (_formKey.currentState?.validate() ?? false) {
                        viewModel.doIntent(
                          LoginButtonClickedEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
