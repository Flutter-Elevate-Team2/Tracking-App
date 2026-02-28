import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/apply_screen_body.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ApplyScreen extends StatelessWidget {
  const ApplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        titleSpacing: 0,
        title: Text((context).l10n.applyTitle),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            context.pop();
          },
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),

      body: BlocProvider(
        create: (context) => getIt<ApplyViewModel>(),
        child: ApplyScreenBody(),
      ),
    );
  }
}