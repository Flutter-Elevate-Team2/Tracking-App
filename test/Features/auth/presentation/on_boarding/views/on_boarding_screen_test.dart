import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/on_boarding/views/on_boarding_screen.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';


void main() {

  testWidgets('OnBoardingScreen displays all elements correctly', (tester) async {

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OnBoardingScreen(),
      ),
    );


    expect(find.byKey(Key("onBoardingLottie")), findsOneWidget);
    expect(find.byKey(Key("welcomeTo")), findsOneWidget);
    expect(find.byKey(Key("floweryRiderApp")), findsOneWidget);
    expect(find.byKey(Key("loginButtonOnBoarding")), findsOneWidget);
    expect(find.byKey(Key("applyButtonOnBoarding")), findsOneWidget);
    expect(find.byKey(Key("versionOnBoarding")), findsOneWidget);

  });
}
