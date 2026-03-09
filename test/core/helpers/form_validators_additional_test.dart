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

  group('FormValidators Additional Coverage', () {
    // --- validateNationalId ---
    testWidgets('validateNationalId returns error for empty value', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateNationalId(ctx, '');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateNationalId returns error for null value', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateNationalId(ctx, null);
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateNationalId returns error for wrong length (not 14)', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateNationalId(
            ctx,
            '1234567890',
          ); // 10 digits
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateNationalId returns error for non-digits', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateNationalId(
            ctx,
            '1234567890123A',
          ); // 14 chars but not all digits
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets(
      'validateNationalId returns null for valid 14-digit national ID',
      (tester) async {
        String? result;
        await tester.pumpWidget(
          createTestWidget((ctx) {
            result = FormValidators.validateNationalId(
              ctx,
              '12345678901234',
            ); // 14 digits
            return const SizedBox();
          }),
        );
        expect(result, isNull);
      },
    );

    // --- validateVehicleNumber ---
    testWidgets('validateVehicleNumber returns error for empty value', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateVehicleNumber(ctx, '');
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateVehicleNumber returns error for null value', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateVehicleNumber(ctx, null);
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets(
      'validateVehicleNumber returns error for too short (<3 chars)',
      (tester) async {
        String? result;
        await tester.pumpWidget(
          createTestWidget((ctx) {
            result = FormValidators.validateVehicleNumber(ctx, 'AB'); // 2 chars
            return const SizedBox();
          }),
        );
        expect(result, isNotNull);
      },
    );

    testWidgets(
      'validateVehicleNumber returns error for too long (>10 chars)',
      (tester) async {
        String? result;
        await tester.pumpWidget(
          createTestWidget((ctx) {
            result = FormValidators.validateVehicleNumber(
              ctx,
              'ABC12345678',
            ); // 11 chars
            return const SizedBox();
          }),
        );
        expect(result, isNotNull);
      },
    );

    testWidgets('validateVehicleNumber returns error for invalid characters', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateVehicleNumber(
            ctx,
            'ABC!@#',
          ); // special chars
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets(
      'validateVehicleNumber returns null for valid alphanumeric (3-10 chars)',
      (tester) async {
        String? result;
        await tester.pumpWidget(
          createTestWidget((ctx) {
            result = FormValidators.validateVehicleNumber(
              ctx,
              'ABC123',
            ); // valid
            return const SizedBox();
          }),
        );
        expect(result, isNull);
      },
    );

    // --- validateLoginPassword additional ---
    testWidgets('validateLoginPassword returns error for less than 8 chars', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateLoginPassword(
            ctx,
            '1234567',
          ); // 7 chars
          return const SizedBox();
        }),
      );
      expect(result, isNotNull);
    });

    testWidgets('validateLoginPassword returns null for exactly 8 chars', (
      tester,
    ) async {
      String? result;
      await tester.pumpWidget(
        createTestWidget((ctx) {
          result = FormValidators.validateLoginPassword(
            ctx,
            '12345678',
          ); // 8 chars
          return const SizedBox();
        }),
      );
      expect(result, isNull);
    });
  });
}
