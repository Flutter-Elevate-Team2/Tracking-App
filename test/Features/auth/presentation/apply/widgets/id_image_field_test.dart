import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/id_image_field.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugins.flutter.io/image_picker');

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Widget createWidgetUnderTest({required ValueChanged<File> onFileSelected}) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: IdImageField(onFileSelected: onFileSelected),
      ),
    );
  }

  testWidgets('Should pick ID image and update UI with success icon', (tester) async {
    File? selectedFile;
    const String mockPath = '/mock/path/id_card.png';

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
      await Future.delayed(const Duration(milliseconds: 200));
    });

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);

    expect(find.textContaining('id_card'), findsWidgets);

    expect(selectedFile, isNotNull);
    expect(selectedFile!.path, mockPath);
  });  testWidgets('Should not update UI if image picking is cancelled', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (methodCall) async {
      return null;
    });

    await tester.pumpWidget(createWidgetUnderTest(onFileSelected: (_) {}));

    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);
    expect(find.byType(Image), findsNothing);
  });
}