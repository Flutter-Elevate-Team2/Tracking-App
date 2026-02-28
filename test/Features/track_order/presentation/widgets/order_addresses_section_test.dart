import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/address_section.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_addresses_section.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
   final fakeOrder = OrderTrackingEntity(
    orderNumber: "123",
    updatedAt: DateTime.now(),
    status: "pending",
    totalPrice: 100,
    paymentType: "cash",
    shippingAddress: "User Home Address",
    store: StoreEntity(
      storeName: "Flowery Store",
      storeAddress: "Store Street 10",
      storeImage: "",
      storePhone: "010111",
      storeLat: 123,
      storeLong: 123,
    ),
    user: UserEntity(
      userName: "Ahmed Ali",
      userImage: "",
      userPhone: "010222",
      deviceToken: "",
    ),
    items: [], id: '',
     trackingLocation: TrackingLocationEntity(
       lat: 123,
       long: 123,
     ),
     userLocationEntity: UserLocationEntity(
       lat: 123,
       long: 123,
     ),
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: OrderAddressesSection(order: fakeOrder),
      ),
    );
  }

  group('OrderAddressesSection Widget Tests', () {
    testWidgets('should render two AddressSection widgets', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(AddressSection), findsNWidgets(2));
    });

    testWidgets('should pass correct store data to the first AddressSection', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.text("Flowery Store"), findsOneWidget);
      expect(find.text("Store Street 10"), findsOneWidget);
    });

    testWidgets('should pass correct user data to the second AddressSection', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.text("Ahmed Ali"), findsOneWidget);
      expect(find.text("User Home Address"), findsOneWidget);
    });
  });
}