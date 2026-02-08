import 'package:flutter/material.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/edit_profile_screen_body.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const EditProfileScreenBody(),
    );
  }
}
