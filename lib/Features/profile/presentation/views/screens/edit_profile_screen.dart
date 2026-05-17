import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/edit_profile_screen_body.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(context.l10n.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.read<ProfileViewModel>().doIntent(GetDriverProfileEvent());
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: const EditProfileScreenBody(),
    );
  }
}
