import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_shimmer_loading.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_view_body.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/order_card.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createWidgetUnderTest({bool isLoading = false}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: HomeViewBody(isLoading: isLoading)),
    );
  }

  group('HomeView Widget Tests', () {
    testWidgets('renders HomeView and HomeHeader', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(HomeHeader), findsOneWidget);
        expect(find.text('Flowery rider'), findsOneWidget);
      });
    });

    testWidgets('renders multiple OrderCards when not loading', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest(isLoading: false));
        await tester.pumpAndSettle();

        expect(find.byType(OrderCard), findsWidgets);
      });
    });

    testWidgets('renders HomeShimmerLoading when loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(isLoading: true));
      await tester.pump(); // Shimmer might not need pumpAndSettle

      expect(find.byType(HomeShimmerLoading), findsOneWidget);
      expect(find.byType(OrderCard), findsNothing);
    });

    testWidgets('OrderCard displays correct information', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Check for recurring texts in English (based on app_en.arb)
        expect(find.text('Flower order'), findsWidgets);
        expect(find.text('Pickup address'), findsWidgets);
        expect(find.text('User address'), findsWidgets);
        expect(find.text('EGP 3000'), findsWidgets);
        expect(find.text('Accept'), findsWidgets);
        expect(find.text('Reject'), findsWidgets);
      });
    });

    testWidgets('OrderCard has Accept and Reject buttons', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(ElevatedButton), findsWidgets); // Accept button
        expect(find.byType(OutlinedButton), findsWidgets); // Reject button
      });
    });
  });
}
