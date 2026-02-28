import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_directions_use_case.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_order_details_use_case.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/track_order_use_case.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/location_service.dart';

import 'track_order_view_model_test.mocks.dart';

@GenerateMocks([
  UpdateOrderStatusUseCase,
  GetOrderDetailsUseCase,
  BuildContext,
  GetDirectionsUseCase,
  LocationService,
  FirebaseOrderService,
])
void main() {
  late OrderStatusViewModel viewModel;
  late MockUpdateOrderStatusUseCase mockUpdateUseCase;
  late MockGetOrderDetailsUseCase mockGetOrderUseCase;
  late MockGetDirectionsUseCase mockGetDirectionsUseCase;
  late MockLocationService mockLocationService;
  late MockFirebaseOrderService mockFirebaseService;
  late MockBuildContext mockContext;

  /// ---------- Fake Data ----------
  const fakeOrderId = "123";
  const fakeUserToken = "token_123";
  const fakeTitle = "Order Title";

  final fakeOrderDetailsData = OrderTrackingEntity(
    orderNumber: "123",
    updatedAt: DateTime.now(),
    status: "pending",
    totalPrice: 120,
    paymentType: "cash",
    store: StoreEntity(
      storeName: "Super Market",
      storeAddress: "123 Street",
      storeImage: "img",
      storePhone: "012",
      storeLat: 123,
      storeLong: 123,
    ),
    user: UserEntity(
      userName: "Ahmed",
      userImage: "user.jpg",
      userPhone: "010",
      deviceToken: "token",
    ),
    items: [],
    shippingAddress: "Cairo",
    id: '',
    trackingLocation: TrackingLocationEntity(lat: 123, long: 123),
    userLocationEntity: UserLocationEntity(lat: 123, long: 123),
  );

  setUp(() {
    mockUpdateUseCase = MockUpdateOrderStatusUseCase();
    mockGetOrderUseCase = MockGetOrderDetailsUseCase();
    mockGetDirectionsUseCase = MockGetDirectionsUseCase();
    mockLocationService = MockLocationService();
    mockFirebaseService = MockFirebaseOrderService();
    mockContext = MockBuildContext();

    // Stub the internal Flutter call that AppLocalizations/status needs
    when(
      mockContext.dependOnInheritedWidgetOfExactType(
        aspect: anyNamed('aspect'),
      ),
    ).thenReturn(null);

    SharedPreferences.setMockInitialValues({
      ApiConstants.currentOrderIdKey: "123",
    });

    viewModel = OrderStatusViewModel(
      mockUpdateUseCase,
      mockGetOrderUseCase,
      mockLocationService,
      mockFirebaseService,
      mockGetDirectionsUseCase,
    );
  });
  tearDown(() {
    viewModel.close();
  });

  group('OrderStatusViewModel Tests', () {
    // --- FetchOrderDetailsEvent Tests ---
    blocTest<OrderStatusViewModel, TrackOrderStatusState>(
      'FetchOrderDetailsEvent emits loading then order details on success',
      build: () {
        when(
          mockGetOrderUseCase.call(any),
        ).thenAnswer((_) async => fakeOrderDetailsData);
        return viewModel;
      },
      act: (bloc) =>
          bloc.doIntent(mockContext, FetchOrderDetailsEvent(fakeOrderId)),
      expect: () => [
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState!.isLoading,
          'loading',
          true,
        ),
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState!.data,
          'data',
          fakeOrderDetailsData,
        ),
      ],
    );

    blocTest<OrderStatusViewModel, TrackOrderStatusState>(
      'FetchOrderDetailsEvent emits error when order is null',
      build: () {
        when(mockGetOrderUseCase.call(any)).thenAnswer((_) async => null);
        return viewModel;
      },
      act: (bloc) =>
          bloc.doIntent(mockContext, FetchOrderDetailsEvent(fakeOrderId)),
      expect: () => [
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState!.isLoading,
          'loading',
          true,
        ),
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState!.errorMessage,
          'error',
          "Order Not Found",
        ),
      ],
    );

    blocTest<OrderStatusViewModel, TrackOrderStatusState>(
      'FetchOrderDetailsEvent emits error on exception',
      build: () {
        when(
          mockGetOrderUseCase.call(any),
        ).thenThrow(Exception("Network Error"));
        return viewModel;
      },
      act: (bloc) =>
          bloc.doIntent(mockContext, FetchOrderDetailsEvent(fakeOrderId)),
      expect: () => [
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState!.isLoading,
          'loading',
          true,
        ),
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState!.errorMessage,
          'error',
          contains("Network Error"),
        ),
      ],
    );

    // Testing the 'else' branch in _fetchOrderDetails (when state.orderState?.data != null)
    blocTest<OrderStatusViewModel, TrackOrderStatusState>(
      'FetchOrderDetailsEvent updates existing data loading state',
      build: () {
        when(
          mockGetOrderUseCase.call(any),
        ).thenAnswer((_) async => fakeOrderDetailsData);
        return viewModel;
      },
      seed: () => TrackOrderStatusState(
        orderState: BaseState(data: fakeOrderDetailsData),
      ),
      act: (bloc) =>
          bloc.doIntent(mockContext, FetchOrderDetailsEvent(fakeOrderId)),
      expect: () => [
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState!.isLoading,
          'loading existing',
          true,
        ),
        isA<TrackOrderStatusState>().having(
          (s) => s.orderState!.data,
          'data maintained',
          fakeOrderDetailsData,
        ),
      ],
    );

    // --- UpdateOrderStatusEvent Tests ---
    // blocTest<OrderStatusViewModel, TrackOrderStatusState>(
    //   'UpdateOrderStatusEvent emits update states, and calls fetch order details',
    //   build: () {
    //     // Stub الـ UseCase بحيث يقبل أي body لأن الـ context ممكن يطلع null string
    //     when(mockUpdateUseCase.call(
    //       title: anyNamed('title'),
    //       orderId: anyNamed('orderId'),
    //       status: anyNamed('status'),
    //       userToken: anyNamed('userToken'),
    //       body: any, // استخدم any هنا عشان نتفادى مشكلة الـ body اللي جاي من الـ context
    //     )).thenAnswer((_) async => null);
    //
    //     when(mockGetOrderUseCase.call(any)).thenAnswer((_) async => fakeOrderDetailsData);
    //     return viewModel;
    //   },
    //   act: (bloc) => bloc.doIntent(
    //     mockContext,
    //     UpdateOrderStatusEvent(
    //       orderId: fakeOrderId,
    //       status: OrderStatus.delivered,
    //       userToken: fakeUserToken,
    //       title: fakeTitle,
    //     ),
    //   ),
    //   expect: () => [
    //     // 1. Loading الخاص بالـ Update
    //     isA<TrackOrderStatusState>().having((s) => s.updateStatusState!.isLoading, 'update loading', true),
    //
    //     // 2. نجاح الـ Update (isLoading false)
    //     isA<TrackOrderStatusState>().having((s) => s.updateStatusState!.isLoading, 'update success', false),
    //
    //     // 3. الـ Fetch اللي بيحصل أوتوماتيك بعد النجاح
    //     isA<TrackOrderStatusState>().having((s) => s.orderState!.isLoading, 'fetch loading', true),
    //
    //     // 4. وصول البيانات
    //     isA<TrackOrderStatusState>().having((s) => s.orderState!.data, 'fetch success', fakeOrderDetailsData),
    //   ],
    // );
  });
}
