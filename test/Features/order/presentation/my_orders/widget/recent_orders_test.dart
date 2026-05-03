import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/recent_orders.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_card.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  DriverOrdersEntity createSingleFakeOrder() {
    return DriverOrdersEntity(
      order: OrderEntity(
        id: "1",
        orderNumber: "#12345",
        state: "completed",
      ),
      store: StoreEntity(
        name: "Test Store",
        address: "Test Address",
      ),
    );
  }

  Widget createWidgetUnderTest(List<DriverOrdersEntity> orders) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: SizedBox(
          height: 1000,
          child: RecentOrders(orders),
        ),
      ),
    );
  }

  group('RecentOrders Widget Tests', () {
    testWidgets('should display correct order number in the card', (tester) async {
      await mockNetworkImagesFor(() async {
        final orders = [createSingleFakeOrder()];

        await tester.pumpWidget(createWidgetUnderTest(orders));

      await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

       expect(find.text('#12345'), findsOneWidget);

        expect(find.byType(OrderCard), findsOneWidget);
      });
    });

    testWidgets('should display correct order number in the card', (tester) async {

      await mockNetworkImagesFor(() async {
         final orders = [
          DriverOrdersEntity(
            order: OrderEntity(
              id: "1",
              orderNumber: "#12345",
              state: "completed",
            ),
            store: StoreEntity(
              name: "Test Store",
              address: "Test Address",
              image: "https://example.com/logo.png",
            ),
          )
        ];

        await tester.pumpWidget(createWidgetUnderTest(orders));

         await tester.pump();

         expect(find.text('#12345'), findsOneWidget);
      });
    });  });
}