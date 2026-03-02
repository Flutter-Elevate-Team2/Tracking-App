import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/address_section.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_addresses_section.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'order_addresses_section_test.mocks.dart';

@GenerateMocks([GoRouter])
void main() {
  late MockGoRouter mockRouter;

  final fakeOrder = OrderTrackingEntity(
    id: '1',
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
    items: [],
    trackingLocation: TrackingLocationEntity(lat: 123, long: 123),
    userLocationEntity: UserLocationEntity(lat: 123, long: 123),
  );

  setUp(() {
    mockRouter = MockGoRouter();

    when(
      mockRouter.push(any, extra: anyNamed('extra')),
    ).thenAnswer((_) async => null);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: Scaffold(
          body: SingleChildScrollView(
            child: OrderAddressesSection(order: fakeOrder),
          ),
        ),
      ),
    );
  }

  group('OrderAddressesSection 100% Coverage Tests', () {
    testWidgets('should call navigation for pickup address tap', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text("Store Street 10"));
      await tester.pumpAndSettle();

      verify(
        mockRouter.push(
          Routes.mapPath,
          extra: argThat(
            predicate(
              (arg) =>
                  arg is Map &&
                  arg['isPickup'] == true &&
                  arg['order'] == fakeOrder,
            ),
            named: 'extra',
          ),
        ),
      ).called(1);
    });

    testWidgets('should call navigation for user address tap', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text("User Home Address"));
      await tester.pumpAndSettle();

      verify(
        mockRouter.push(
          Routes.mapPath,
          extra: argThat(
            predicate(
              (arg) =>
                  arg is Map &&
                  arg['isPickup'] == false &&
                  arg['order'] == fakeOrder,
            ),
            named: 'extra',
          ),
        ),
      ).called(1);
    });

    testWidgets('Full Coverage for launch helpers', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final buttons = find.byType(InkWell);

      for (int i = 0; i < buttons.evaluate().length; i++) {
        await tester.tap(buttons.at(i));
        await tester.pump();
      }
    });
    testWidgets('Full Coverage for launch helpers (Phone & WhatsApp)', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final storeSection = find.byType(AddressSection).first;

      final storePhoneBtn = find.descendant(
        of: storeSection,
        matching: find.byIcon(Icons.phone),
      );
      final storeChatBtn = find.descendant(
        of: storeSection,
        matching: find.byIcon(Icons.chat_bubble_outline),
      );

      if (storePhoneBtn.evaluate().isNotEmpty) {
        await tester.tap(storePhoneBtn);
        await tester.pump();
      }
      if (storeChatBtn.evaluate().isNotEmpty) {
        await tester.tap(storeChatBtn);
        await tester.pump();
      }

      final userSection = find.byType(AddressSection).last;

      final userPhoneBtn = find.descendant(
        of: userSection,
        matching: find.byIcon(Icons.phone),
      );
      final userChatBtn = find.descendant(
        of: userSection,
        matching: find.byIcon(Icons.chat_bubble_outline),
      );

      if (userPhoneBtn.evaluate().isNotEmpty) {
        await tester.tap(userPhoneBtn);
        await tester.pump();
      }
      if (userChatBtn.evaluate().isNotEmpty) {
        await tester.tap(userChatBtn);
        await tester.pump();
      }
    });
  });
}