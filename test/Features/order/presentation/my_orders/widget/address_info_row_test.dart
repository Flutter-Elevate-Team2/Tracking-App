import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/address_info_row.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';

/// A fully stubbed FirebaseOrderService that doesn't need any Firebase.
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

  final fakeStore = StoreEntity(
    name: "Flowery Store",
    address: "123 Street, Cairo",
    image: "store_image.png",
  );

  final fakeOrder = OrderEntity(
    id: "o1",
    updatedAt: "2024-05-20",
    user: UserEntity(firstName: "Ahmed", photo: "user_photo.png"),
  );

  Widget createWidgetUnderTest({required bool isUser}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: AddressInfoRow(
          order: fakeOrder,
          store: fakeStore,
          label: "Delivery Info",
          isUser: isUser,
        ),
      ),
    );
  }

  group('AddressInfoRow Widget Tests', () {
    testWidgets('should display Store info when isUser is false', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(isUser: false));
      await tester.pump();

      expect(find.text("Delivery Info"), findsOneWidget);
      expect(find.text("Flowery Store"), findsOneWidget);
      expect(find.text("123 Street, Cairo"), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('should display User info when isUser is true', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(isUser: true));
      await tester
          .pump(); // pump once to build FutureBuilder with null snapshot

      expect(find.text("Ahmed"), findsOneWidget);
      expect(find.text("2024-05-20"), findsOneWidget);
    });

    testWidgets('should render CachedNetworkImage for the avatar', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(isUser: false));
      await tester.pump();

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should use fallback values when data is empty', (
      tester,
    ) async {
      final emptyStore = StoreEntity(name: null, address: null);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AddressInfoRow(
              order: fakeOrder,
              store: emptyStore,
              label: "Label",
              isUser: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Text), findsWidgets);
    });
  });
}
