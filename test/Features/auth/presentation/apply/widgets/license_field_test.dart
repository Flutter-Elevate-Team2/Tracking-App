import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/license_field.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugins.flutter.io/image_picker');

  Widget createWidgetUnderTest({required ValueChanged<File> onFileSelected}) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: LicenseField(onFileSelected: onFileSelected),
      ),
    );
  }

  testWidgets('Should display selected image name and check icon when image is picked', (tester) async {
    File? selectedFile;
    const String mockPath = '/mock/path/test_license.jpg';

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (methodCall) async {
      if (methodCall.method == 'pickImage') {
        return mockPath;
      }
      return null;
    });

    await tester.pumpWidget(createWidgetUnderTest(
      onFileSelected: (file) => selectedFile = file,
    ));

    await tester.tap(find.byType(TextFormField));

   await tester.runAsync(() async {
      await Future.delayed(Duration.zero);
    });

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('test_license.jpg'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);

    expect(selectedFile, isNotNull);
    expect(selectedFile!.path, mockPath);
  });  testWidgets('Should not change state if picking is cancelled', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (methodCall) async {
      return null;
    });

    await tester.pumpWidget(createWidgetUnderTest(onFileSelected: (_) {}));

    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);
  });
}