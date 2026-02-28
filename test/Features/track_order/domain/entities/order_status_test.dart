import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createLocalizationsWidget(WidgetBuilder builder) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate, //
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: Builder(builder: builder),
    );
  }

  group('OrderStatus Enum Comprehensive Tests', () {
    test('fromFirebase mapping coverage', () {
      expect(OrderStatus.fromFirebase('accepted'), OrderStatus.accepted);
      expect(
        OrderStatus.fromFirebase('arrived_pickup'),
        OrderStatus.arrivedPickup,
      );
      expect(
        OrderStatus.fromFirebase('start_deliver'),
        OrderStatus.startDeliver,
      );
      expect(OrderStatus.fromFirebase('arrived_user'), OrderStatus.arrivedUser);
      expect(OrderStatus.fromFirebase('delivered'), OrderStatus.delivered);
      expect(OrderStatus.fromFirebase('unknown'), OrderStatus.accepted);
    });

    test('next status transition coverage', () {
      expect(OrderStatus.accepted.next, OrderStatus.arrivedPickup);
      expect(OrderStatus.arrivedPickup.next, OrderStatus.startDeliver);
      expect(OrderStatus.startDeliver.next, OrderStatus.arrivedUser);
      expect(OrderStatus.arrivedUser.next, OrderStatus.delivered);
      expect(OrderStatus.delivered.next, isNull);
    });

    testWidgets('DisplayName, NotificationBody, and ButtonText coverage', (
      tester,
    ) async {
      await tester.pumpWidget(
        createLocalizationsWidget((context) {
          for (var status in OrderStatus.values) {
            final displayName = status.getDisplayName(context);
            final notificationBody = status.getNotificationBody(context);
            final buttonText = status.getButtonText(context);

            expect(displayName, isNotEmpty);
            expect(notificationBody, isA<String>());
            expect(buttonText, isA<String>());
          }
          return const Placeholder();
        }),
      );
    });
  });
}
