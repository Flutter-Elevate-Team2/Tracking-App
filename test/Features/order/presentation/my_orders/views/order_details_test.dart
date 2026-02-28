import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/orders_item_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/product_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/views/order_details.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/address_info_row.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_item_tile.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_summary_card.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  final fakeOrder = DriverOrdersEntity(
    order: OrderEntity(
      id: "123",
      orderNumber: "#999",
      state: "pending",
      totalPrice: 500,
      paymentType: "Cash",
      orderItems: [
        OrdersItemEntity(
          quantity: 2,
          price: 150,
          product: ProductEntity(title: "Product 1", imgCover: ""),
        ),
        OrdersItemEntity(
          quantity: 1,
          price: 200,
          product: ProductEntity(title: "Product 2", imgCover: ""),
        ),
      ],
    ),
    store: StoreEntity(name: "Test Store", address: "Store Address"),
  );

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              OrderDetailsDisplayBody(order: fakeOrder),
        ),
      ],
    );

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }

  group('OrderDetailsDisplayBody Widget Tests', () {
    testWidgets(
      'should render order number, state, and address rows correctly',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pump();

          expect(find.text('#999'), findsOneWidget);
          expect(find.byType(OrderState), findsOneWidget);
          expect(find.byType(AddressInfoRow), findsNWidgets(2));
        });
      },
    );

    testWidgets('should render the correct number of order items with titles', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.text('Product 1'), findsOneWidget);
        expect(find.text('Product 2'), findsOneWidget);
        expect(find.byType(OrderItemTile), findsNWidgets(2));
      });
    });

    testWidgets(
      'should display order summary card with correct price and payment method',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pump();

          expect(find.byType(OrderSummaryCard), findsOneWidget);
          expect(find.textContaining('500'), findsOneWidget);
          expect(find.text('Cash'), findsOneWidget);
        });
      },
    );
  });
}
