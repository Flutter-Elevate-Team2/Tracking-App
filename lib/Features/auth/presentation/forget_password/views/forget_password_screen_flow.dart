import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/shared/forget_password_screen_flow_body.dart';
import 'package:tracking_app/core/di/di.dart';

class ForgetPasswordScreenFlow extends StatelessWidget {
  const ForgetPasswordScreenFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgetPasswordViewModel>(),
      child: const ForgetPasswordScreenFlowBody(),
    );
  }
}
