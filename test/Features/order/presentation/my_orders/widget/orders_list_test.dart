import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_card.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/orders_list.dart';
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

  List<DriverOrdersEntity> createFakeOrders(int count) {
    return List.generate(
      count,
      (index) => DriverOrdersEntity(
        order: OrderEntity(
          id: index.toString(),
          orderNumber: "#$index",
          state: "pending",
        ),
        store: StoreEntity(name: "Store $index", address: "Address $index"),
      ),
    );
  }

  Widget createWidgetUnderTest(List<DriverOrdersEntity> orders) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: OrdersList(orders)),
    );
  }

  group('OrdersList Widget Tests', () {
    testWidgets('should be scrollable when items exceed screen height', (
      tester,
    ) async {
      final longList = createFakeOrders(20);

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest(longList));
        await tester.pump();

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        expect(find.byType(OrderCard), findsWidgets);
      });
    });

    testWidgets('should show nothing when list is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest([]));
      await tester.pump();

      expect(find.byType(OrderCard), findsNothing);
    });
  });
}
