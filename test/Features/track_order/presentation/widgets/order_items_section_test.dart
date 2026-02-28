import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_item_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_item_tile.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_items_section.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
   final fakeStore = StoreEntity(storeName: "Flowery", storeAddress: "Addr", storeImage: "", storePhone: "");
  final fakeUser = UserEntity(userName: "User", userImage: "", userPhone: "", deviceToken: "");

  final fakeItems = [
    OrderItemEntity(name: "Red Rose", price: "50", quantity: 2, image: "rose.jpg"),
    OrderItemEntity(name: "White Lily", price: "80", quantity: 1, image: "lily.jpg"),
  ];

  final fakeOrder = OrderTrackingEntity(
    orderNumber: "101",
    updatedAt: DateTime.now(),
    status: "delivering",
    totalPrice: 180.0,
    paymentType: "card",
    shippingAddress: "Cairo",
    store: fakeStore,
    user: fakeUser,
    items: fakeItems,
  );

   Widget createWidgetUnderTest({OrderTrackingEntity? order}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: OrderItemsSection(order: order ?? fakeOrder),
        ),
      ),
    );
  }

  group('OrderItemsSection Widget Tests', () {
    testWidgets('should display section title correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final titleFinder = find.byType(Text).first;
      expect(titleFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(titleFinder);
      expect(textWidget.data, isNotEmpty);
    });

    testWidgets('should render correct number of OrderItemTile widgets', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(OrderItemTile), findsNWidgets(fakeItems.length));
    });

    testWidgets('should pass correct data from items list to OrderItemTile', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("Red Rose"), findsOneWidget);
      expect(find.text("X2"), findsOneWidget);
      expect(find.text("White Lily"), findsOneWidget);
      expect(find.text("X1"), findsOneWidget);
    });

    testWidgets('should handle empty items list gracefully', (tester) async {
       final emptyOrder = OrderTrackingEntity(
        orderNumber: '102',
        updatedAt: DateTime.now(),
        status: 'pending',
        totalPrice: 0.0,
        paymentType: 'cash',
        store: fakeStore,
        user: fakeUser,
        shippingAddress: 'No Address',
        items: [],
      );

      await tester.pumpWidget(createWidgetUnderTest(order: emptyOrder));

       expect(find.byType(Text).first, findsOneWidget);
       expect(find.byType(OrderItemTile), findsNothing);
    });
  });
}