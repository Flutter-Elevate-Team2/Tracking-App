import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/country_field.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/country_entities.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockCountriesJson = json.encode([
    {"name": "Egypt", "flag": "🇪🇬", "code": "EG"},
    {"name": "Afghanistan", "flag": "🇦🇫", "code": "AF"},
  ]);

  void setupMock(WidgetTester tester) {
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
          (ByteData? message) async {
        return ByteData.view(Uint8List.fromList(utf8.encode(mockCountriesJson)).buffer);
      },
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: CountryField(onChanged: (country) {}),
      ),
    );
  }

  // testWidgets('Should show loading then display initial country (Egypt)', (tester) async {
  //   setupMock(tester);
  //
  //   await tester.pumpWidget(createWidgetUnderTest());
  //
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
  //
  //   await tester.runAsync(() async => await Future.delayed(Duration.zero));
  //
  //   await tester.pump();
  //   await tester.pump(const Duration(milliseconds: 100));
  //
  //   expect(find.textContaining('Egypt'), findsOneWidget);
  //   expect(find.byType(CircularProgressIndicator), findsNothing);
  // });

  testWidgets('Should open list and select Afghanistan', (tester) async {
    setupMock(tester);

    await tester.pumpWidget(createWidgetUnderTest());


    await tester.pump();

    await tester.tap(find.byType(DropdownButtonFormField<CountryEntity>));
    await tester.pumpAndSettle();

    final item = find.textContaining('Afghanistan').last;
    await tester.tap(item);
    await tester.pumpAndSettle();

    expect(find.textContaining('Afghanistan'), findsWidgets);
  });
}