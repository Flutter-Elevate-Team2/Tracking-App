import 'package:flutter/material.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/apply_form.dart';

class ApplyScreenBody extends StatelessWidget {
  const ApplyScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 22),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 24),
            ApplyForm(),
          ],
        ),
      ),
    );
  }
}
