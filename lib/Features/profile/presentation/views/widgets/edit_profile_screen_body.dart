import 'package:flutter/material.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/edit_profile_form_screen.dart';

class EditProfileScreenBody extends StatelessWidget {
  const EditProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
          const  SizedBox(height: 24),
           const EditProfileForm(),
          ],
        ),
      ),
    );
  }
}

