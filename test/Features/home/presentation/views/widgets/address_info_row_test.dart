import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/address_info_row.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createWidgetUnderTest({
    required String label,
    required String name,
    required String address,
    required Widget leading,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: AddressInfoRow(
          label: label,
          name: name,
          address: address,
          leading: leading,
        ),
      ),
    );
  }

  testWidgets('AddressInfoRow renders all information correctly', (
    WidgetTester tester,
  ) async {
    const label = 'Pickup address';
    const name = 'Flowery store';
    const address = '20th st, Giza';
    const leading = Icon(Icons.store);

    await tester.pumpWidget(
      createWidgetUnderTest(
        label: label,
        name: name,
        address: address,
        leading: leading,
      ),
    );

    expect(find.text(label), findsOneWidget);
    expect(find.text(name), findsOneWidget);
    expect(find.text(address), findsOneWidget);
    expect(find.byIcon(Icons.store), findsOneWidget);
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
  });
}
