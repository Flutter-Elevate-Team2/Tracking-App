import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/address_info_row.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_card.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_state.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';

class FakeFirebaseOrderService implements FirebaseOrderService {
  @override
  Future<OrderTrackingFirebaseModel?> getTrackingOrderById(
    String orderId,
  ) async => null;
  @override
  Future<Map<String, dynamic>?> getUserDataByOrderId(String orderId) async =>
      null;
  @override
  Future<Map<String, dynamic>?> getUserDataByUserId(String userId) async =>
      null;
  @override
  Future<void> uploadTrackingOrder(
    String orderId,
    Map<String, dynamic> trackingData,
  ) async {}
  @override
  Future<void> updateOrderLocation(
    String orderId,
    Map<String, dynamic> data,
  ) async {}
  @override
  Future<void> updateDriverTokenInActiveOrder(
    String orderId,
    String newToken,
  ) async {}
  @override
  Stream<OrderTrackingFirebaseModel> watchOrder(String orderId) =>
      const Stream.empty();
}

void main() {
  setUp(() {
    GetIt.instance.allowReassignment = true;
    GetIt.instance.registerSingleton<FirebaseOrderService>(
      FakeFirebaseOrderService(),
    );
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  final fakeDriverOrder = DriverOrdersEntity(
    order: OrderEntity(id: "123", orderNumber: "#999", state: "pending"),
    store: StoreEntity(name: "Test Store", address: "Store Address"),
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: OrderCard(orders: fakeDriverOrder)),
    );
  }

  group('OrderCard Widget Tests', () {
    testWidgets('should render all components of the order card', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('#999'), findsOneWidget);
        expect(find.byType(AddressInfoRow), findsNWidgets(2));
      });
    });
    testWidgets('should show OrderState correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(OrderState), findsOneWidget);
      });
    });
  });
}
