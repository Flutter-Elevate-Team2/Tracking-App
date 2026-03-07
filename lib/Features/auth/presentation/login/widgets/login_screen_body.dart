import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/login_form.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocListener<LoginViewModel, LoginState>(
          listenWhen: (p, c) => p.loginState != c.loginState,
          listener: _onLoginStateChanged,
          child: const LoginForm(),
        ),
      ),
    );
  }

  void _onLoginStateChanged(BuildContext context, LoginState state) {
    final loginState = state.loginState;

    if (loginState?.data != null) {
      // If there's an active order, trap the driver
      if (state.activeOrderId != null) {
        context.go('${Routes.trackOrderPath}/${state.activeOrderId}');
      } else {
        context.goNamed(Routes.homeName);
      }
    } else if (loginState?.errorMessage != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(loginState!.errorMessage!),
            backgroundColor: AppColors.red,
          ),
        );
    }
  }
}
