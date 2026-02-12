import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_text_form_field.dart';

void main() {
  group('ProfileTextField', () {
    testWidgets('renders label and initial value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileTextField(
              label: 'Full Name',
              initialValue: 'John Doe',
            ),
          ),
        ),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('uses controller when provided', (tester) async {
      final controller = TextEditingController(text: 'Initial Text');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileTextField(label: 'Test Label', controller: controller),
          ),
        ),
      );

      expect(find.text('Initial Text'), findsOneWidget);

      controller.text = 'Updated Text';
      await tester.pump();
      expect(find.text('Updated Text'), findsOneWidget);
    });

    testWidgets('shows error when validation fails', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: ProfileTextField(
                label: 'Email',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);
    });
  });
}
