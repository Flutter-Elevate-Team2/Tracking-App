import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/views/order_map_screen.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/custom_map_back_button.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/map_bottom_sheet.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/order_map_body.dart';
import 'package:tracking_app/core/di/di.dart';

import '../widgets/track_order_body_test.mocks.dart';

void main() {
  late MockOrderStatusViewModel mockViewModel;

  final mockOrder = OrderTrackingEntity(
    id: '123',
    paymentType: '',
    user: UserEntity(
      userName: 'userName',
      userImage: 'userImage',
      userPhone: 'userPhone',
      deviceToken: 'deviceToken',
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

  setUp(() async {
    mockViewModel = MockOrderStatusViewModel();
    await getIt.reset();
    getIt.registerFactory<OrderStatusViewModel>(() => mockViewModel);

    when(mockViewModel.changeTarget(any)).thenReturn(null);
    when(mockViewModel.doIntent(any, any)).thenReturn(null);
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockViewModel.state).thenReturn(const TrackOrderStatusState());
  });

  Future<void> pumpOrderMapScreen(
    WidgetTester tester,
    bool initialPickup,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OrderMapScreen(
          order: mockOrder,
          initialShowPickup: initialPickup,
        ),
      ),
    );
  }

  group('OrderMapScreen Coverage Tests', () {
    testWidgets(
      'Should initialize ViewModel with correct order ID and true pickup',
      (tester) async {
        await pumpOrderMapScreen(tester, true);

        verify(mockViewModel.changeTarget(true)).called(1);

        verify(
          mockViewModel.doIntent(
            argThat(isA<BuildContext>()),
            argThat(isA<FetchOrderDetailsEvent>()),
          ),
        ).called(1);
      },
    );

    testWidgets('Should initialize ViewModel with false pickup when passed', (
      tester,
    ) async {
      await pumpOrderMapScreen(tester, false);

      verify(mockViewModel.changeTarget(false)).called(1);
    });

    testWidgets('Full UI Stack Coverage', (tester) async {
      await pumpOrderMapScreen(tester, true);

      final stackFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Stack &&
            widget.children.any((child) => child is OrderMapBody),
      );

      // Assert
      expect(stackFinder, findsOneWidget);

      expect(find.byType(OrderMapBody), findsOneWidget);
      expect(find.byType(CustomMapBackButton), findsOneWidget);
      expect(find.byType(MapBottomSheet), findsOneWidget);

      final positionedFinder = find.byType(Positioned);
      expect(positionedFinder, findsWidgets);
    });
  });
}
