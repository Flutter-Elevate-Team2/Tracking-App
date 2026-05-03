import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_card.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/address_info_row.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_state.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  final fakeDriverOrder = DriverOrdersEntity(
    order: OrderEntity(
      id: "123",
      orderNumber: "#999",
      state: "pending",
    ),
    store: StoreEntity(
      name: "Test Store",
      address: "Store Address",
    ),
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: OrderCard(orders: fakeDriverOrder),
      ),
    );
  }

  group('OrderCard Widget Tests', () {
    testWidgets('should render all components of the order card', (tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('#999'), findsOneWidget);

        expect(find.byType(AddressInfoRow), findsNWidgets(2));
      });
    });
    testWidgets('should show OrderState correctly', (tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(OrderState), findsOneWidget);
      });
    });
  });
}