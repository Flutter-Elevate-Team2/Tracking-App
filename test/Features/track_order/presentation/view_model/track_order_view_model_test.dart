import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/location_service.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_directions_use_case.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_order_details_use_case.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/track_order_use_case.dart';

import 'track_order_view_model_test.mocks.dart';

@GenerateMocks(
  [
    UpdateOrderStatusUseCase,
    GetOrderDetailsUseCase,
    GetDirectionsUseCase,
    LocationService,
    FirebaseOrderService,
  ],
  customMocks: [
    MockSpec<BuildContext>(onMissingStub: OnMissingStub.returnDefault),
  ],
)
void main() {
  late OrderStatusViewModel viewModel;
  late MockUpdateOrderStatusUseCase mockUpdateUseCase;
  late MockGetOrderDetailsUseCase mockGetOrderUseCase;
  late MockGetDirectionsUseCase mockGetDirectionsUseCase;
  late MockLocationService mockLocationService;
  late MockFirebaseOrderService mockFirebaseService;
  late MockBuildContext mockContext;

  final fakeOrder = OrderTrackingEntity(
    id: "123",
    orderNumber: "1",
    status: "pending",
    totalPrice: 100,
    paymentType: "Cash",
    items: [],
    shippingAddress: "Cairo",
    updatedAt: DateTime.now(),
    user: UserEntity(
      userName: "U",
      userImage: "I",
      userPhone: "P",
      deviceToken: "D",
    ),
    trackingLocation: TrackingLocationEntity(lat: 30.0, long: 31.0),
    userLocationEntity: UserLocationEntity(lat: 30.2, long: 31.2),
    store: StoreEntity(
      storeName: 'S',
      storeAddress: 'A',
      storeImage: 'I',
      storePhone: 'P',
      storeLat: 30.1,
      storeLong: 31.1,
    ),
  );

  final fakePosition = Position(
    latitude: 30.0,
    longitude: 31.0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

  setUp(() {
    mockUpdateUseCase = MockUpdateOrderStatusUseCase();
    mockGetOrderUseCase = MockGetOrderDetailsUseCase();
    mockGetDirectionsUseCase = MockGetDirectionsUseCase();
    mockLocationService = MockLocationService();
    mockFirebaseService = MockFirebaseOrderService();
    mockContext = MockBuildContext();

    when(
      mockLocationService.getCurrentLocation(),
    ).thenAnswer((_) async => fakePosition);
    when(
      mockLocationService.getLocationStream(),
    ).thenAnswer((_) => Stream.value(fakePosition));
    when(
      mockGetDirectionsUseCase.call(any, any),
    ).thenAnswer((_) async => [mapbox.Position(31.0, 30.0)]);

    SharedPreferences.setMockInitialValues({});
    viewModel = OrderStatusViewModel(
      mockUpdateUseCase,
      mockGetOrderUseCase,
      mockLocationService,
      mockFirebaseService,
      mockGetDirectionsUseCase,
    );
  });

  group('OrderStatusViewModel 100% Coverage', () {
    // 1. اختبار FetchOrderDetails (نجاح)
    blocTest<OrderStatusViewModel, TrackOrderStatusState>(
      'FetchOrderDetails: Success path',
      build: () {
        when(mockGetOrderUseCase.call(any)).thenAnswer((_) async => fakeOrder);
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(mockContext, FetchOrderDetailsEvent("123")),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState?.isLoading,
          'loading',
          true,
        ),
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState?.data,
          'data',
          fakeOrder,
        ),
        isA<TrackOrderStatusState>().having(
          (s) => s.currentDriverPosition,
          'initialPos',
          isNotNull,
        ),
        isA<TrackOrderStatusState>().having(
          (s) => s.routePoints,
          'route',
          isNotEmpty,
        ),
        isA<TrackOrderStatusState>(), // من getCurrentLocation.then
      ],
    );

    // 2. اختبار FetchOrderDetails (بيانات فارغة - تغطية else)
    blocTest<OrderStatusViewModel, TrackOrderStatusState>(
      'FetchOrderDetails: Not Found path',
      build: () {
        when(mockGetOrderUseCase.call(any)).thenAnswer((_) async => null);
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(mockContext, FetchOrderDetailsEvent("123")),
      expect: () => [
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState?.isLoading,
          'loading',
          true,
        ),
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState?.errorMessage,
          'error',
          "Order Not Found",
        ),
      ],
    );

    // 3. اختبار UpdateStatus (نجاح + تغطية delivered + تغطية refetch)
    // blocTest<OrderStatusViewModel, TrackOrderStatusState>(
    //   'UpdateStatus: Delivered Success',
    //   build: () {
    //     // تأكدي إن كل الـ arguments واخدة anyNamed
    //     when(mockUpdateUseCase.call(
    //       title: anyNamed('title'),
    //       orderId: anyNamed('orderId'),
    //       status: anyNamed('status'),
    //       userToken: anyNamed('userToken'),
    //       body: anyNamed('body'), // ده التعديل المهم
    //     )).thenAnswer((_) async => Future.value());
    //
    //     when(mockGetOrderUseCase.call(any)).thenAnswer((_) async => fakeOrder);
    //     return viewModel;
    //   },
    //   act: (bloc) => bloc.doIntent(mockContext, UpdateOrderStatusEvent(
    //       orderId: "123", status: OrderStatus.delivered, userToken: "T", title: "T"
    //   )),
    //   wait: const Duration(milliseconds: 500),
    //   verify: (_) {
    //     verify(mockUpdateUseCase.call(
    //       title: anyNamed('title'),
    //       orderId: anyNamed('orderId'),
    //       status: anyNamed('status'),
    //       userToken: anyNamed('userToken'),
    //       body: anyNamed('body'), // لازم هنا كمان يتصلح
    //     )).called(1);
    //   },
    // );
    //
    // // 4. اختبار UpdateStatus (فشل - تغطية catch)
    // blocTest<OrderStatusViewModel, TrackOrderStatusState>(
    //   'UpdateStatus: Failure path',
    //   build: () {
    //     when(mockUpdateUseCase.call(
    //       title: anyNamed('title'),
    //       orderId: anyNamed('orderId'),
    //       status: anyNamed('status'),
    //       userToken: anyNamed('userToken'),
    //       body: anyNamed('body'), // هنا كمان
    //     )).thenThrow(Exception("Update Failed"));
    //     return viewModel;
    //   },
    //   act: (bloc) => bloc.doIntent(mockContext, UpdateOrderStatusEvent(
    //       orderId: "123", status: OrderStatus.accepted, userToken: "T", title: "T"
    //   )),
    //   expect: () => [
    //     isA<TrackOrderStatusState>().having((s) => s.updateStatusState?.isLoading, 'update loading', true),
    //     isA<TrackOrderStatusState>().having((s) => s.updateStatusState?.errorMessage, 'error', contains("Update Failed")),
    //   ],
    // );

    // 5. تغطية الـ changeTarget والـ Branching
    test('changeTarget should toggle showPickup and update route', () async {
      viewModel.emit(
        viewModel.state.copyWith(
          orderState: BaseState(data: fakeOrder),
          currentDriverPosition: fakePosition,
        ),
      );

      viewModel.changeTarget(false); // User Location
      expect(viewModel.state.showPickup, false);

      viewModel.changeTarget(true); // Store Location
      expect(viewModel.state.showPickup, true);

      await Future.delayed(Duration.zero);
      verify(mockGetDirectionsUseCase.call(any, any)).called(greaterThan(0));
    });
  });
}
