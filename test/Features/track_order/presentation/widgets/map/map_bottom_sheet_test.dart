import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/address_section.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/map_bottom_sheet.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'map_bottom_sheet_test.mocks.dart';

@GenerateMocks([OrderStatusViewModel])
void main() {
  late MockOrderStatusViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockOrderStatusViewModel();
  });

  Widget createWidgetUnderTest(TrackOrderStatusState state) {
    when(mockViewModel.state).thenReturn(state);
    when(mockViewModel.stream).thenAnswer((_) => Stream.value(state));

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<OrderStatusViewModel>.value(
        value: mockViewModel,
        child: const Scaffold(body: MapBottomSheet()),
      ),
    );
  }

  final mockOrder = OrderTrackingEntity(
    id: '123',
    paymentType: '',
    user: UserEntity(
      userName: 'userName',
      userImage: 'userImage',
      userPhone: 'userPhone',
      deviceToken: 'deviceToken',
      userId: 'userId',
    ),
    orderNumber: 'ORD-1',
    status: 'accepted',
    items: [],
    totalPrice: 100,
    shippingAddress: 'Cairo',
    updatedAt: DateTime.now(),
    store: StoreEntity(
      storeName: 'storeName',
      storeAddress: 'storeAddress',
      storeImage: 'storeImage',
      storePhone: 'storePhone',
      storeLat: 122,
      storeLong: 122,
    ),
    trackingLocation: TrackingLocationEntity(lat: 30.0, long: 31.0),
    userLocationEntity: UserLocationEntity(lat: 30.2, long: 31.2),
  );

  group('MapBottomSheet Coverage Tests', () {
    testWidgets('should show SizedBox when order is null', (tester) async {
      final state = TrackOrderStatusState(orderState: null);
      await tester.pumpWidget(createWidgetUnderTest(state));

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('should render addresses and handle changeTarget tap', (
      tester,
    ) async {
      final state = TrackOrderStatusState(
        showPickup: true,
        orderState: BaseState(data: mockOrder),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));

      expect(find.byType(AddressSection), findsNWidgets(2));

      await tester.tap(find.byType(GestureDetector).first);
      verify(mockViewModel.changeTarget(any)).called(1);
    });

    testWidgets(
      'should change order of cards based on showPickup (Coverage Else Block)',
      (tester) async {
        final state = TrackOrderStatusState(
          showPickup: false,
          orderState: BaseState(data: mockOrder),
        );

        await tester.pumpWidget(createWidgetUnderTest(state));

        expect(find.byType(MapBottomSheet), findsOneWidget);

        final addressSections = tester
            .widgetList<AddressSection>(find.byType(AddressSection))
            .toList();

        expect(addressSections.first.label, contains('User address'));
      },
    );

    testWidgets('should trigger phone and chat launches for coverage', (
      tester,
    ) async {
      final state = TrackOrderStatusState(
        orderState: BaseState(data: mockOrder),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));

      final buttons = find.byType(InkWell);
      if (buttons.evaluate().isNotEmpty) {
        for (var i = 0; i < buttons.evaluate().length; i++) {
          await tester.tap(buttons.at(i));
          await tester.pump();
        }
      }
    });
  });
}
