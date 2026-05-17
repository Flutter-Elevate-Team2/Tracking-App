import 'package:flutter/material.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/apply_form.dart';

class ApplyScreenBody extends StatelessWidget {
  const ApplyScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Welcome!!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'You want to be a delivery man?\nJoin our team',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const ApplyForm(),
          ],
        ),
      ),
    );
  }
}
