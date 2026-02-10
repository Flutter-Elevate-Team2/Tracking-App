import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/login_screen_body.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        titleSpacing: 0,
        title: Text((context).l10n.loginTitle),
        leading: InkWell(
          onTap: () {
            // Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<LoginViewModel>(),
        child: LoginScreenBody(),
      ),
    );
  }
}
