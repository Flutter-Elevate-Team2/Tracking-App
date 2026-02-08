import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createTestWidget(Widget Function(BuildContext) builder) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: builder),
    );
  }

  group('FormValidators', () {
    // --- Email ---
    testWidgets('validateEmail returns required error for empty', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validateEmail(context, '');
          return const SizedBox();
        }),
      );
      expect(result, AppLocalizations.supportedLocales.isNotEmpty ? isNotNull : isNotNull);
    });

    testWidgets('validateEmail returns invalid error for wrong format', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validateEmail(context, 'invalid-email');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateEmail returns null for valid email', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validateEmail(context, 'test@example.com');
          return const SizedBox();
        }),
      );
      expect(result, null);
    });

    // --- Password ---
    testWidgets('validatePassword returns required for empty', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validatePassword(context, '');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validatePassword returns too short for short password', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validatePassword(context, '123');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validatePassword returns weak for weak password', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validatePassword(context, 'abcdefgh'); // assume fails regex
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validatePassword returns null for strong password', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validatePassword(context, 'Abc12345!');
          return const SizedBox();
        }),
      );
      expect(result, null);
    });

    // --- Confirm Password ---
    testWidgets('validateConfirmPassword returns required for empty', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validateConfirmPassword(context, '', 'password');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateConfirmPassword returns mismatch when different', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validateConfirmPassword(context, 'abc', 'password');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateConfirmPassword returns null when matches', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validateConfirmPassword(context, 'password', 'password');
          return const SizedBox();
        }),
      );
      expect(result, null);
    });

    // --- Phone ---
    testWidgets('validatePhone returns required for empty', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validatePhone(context, '');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validatePhone returns invalid for wrong format', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validatePhone(context, 'abc123');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validatePhone returns null for valid phone', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validatePhone(context, '+201234567890');
          return const SizedBox();
        }),
      );
      expect(result, null);
    });

    // --- validateRequired ---
    test('validateRequired returns error for null', () {
      final result = FormValidators.validateRequired(null, 'Required');
      expect(result, 'Required');
    });

    test('validateRequired returns null for non-empty', () {
      final result = FormValidators.validateRequired('value', 'Required');
      expect(result, null);
    });

    // --- validateLoginPassword ---
    testWidgets('validateLoginPassword returns required for empty', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validateLoginPassword(context, '');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateLoginPassword returns null for non-empty', (tester) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((context) {
          result = FormValidators.validateLoginPassword(context, 'mypassword');
          return const SizedBox();
        }),
      );
      expect(result, null);
    });
  });
}
