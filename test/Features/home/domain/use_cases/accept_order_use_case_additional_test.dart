import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/use_cases/accept_order_use_case.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'accept_order_use_case_test.mocks.dart';

void main() {
  late MockStartOrderUseCase mockStartOrder;
  late MockFirebaseOrderService mockFirebase;
  late MockSessionController mockSession;
  late MockLocationService mockLocation;
  late MockGetDriverProfileUseCase mockGetProfile;
  late MockSharedPreferences mockPrefs;
  late MockGetVehicleUseCase mockGetVehicle;
  late MockActiveOrderFirestoreService mockActiveOrderService;
  late AcceptOrderUseCase useCase;

  final tOrder = OrderEntity(
    id: '123',
    orderNumber: '#1',
    user: const OrderUserEntity(
      id: 'u1',
      firstName: 'Ali',
      lastName: 'Baba',
      email: 'ali@test.com',
      phone: '0123',
      photo: '',
    ),
    shippingAddress: const ShippingAddressEntity(
      street: 'St',
      city: 'City',
      lat: '30.0',
      long: '31.0',
    ),
    orderItems: [
      const OrderItemEntity(
        id: 'i1',
        price: 50,
        quantity: 2,
        product: ProductEntity(id: 'p1', title: 'Prod', imgCover: ''),
      ),
    ],
  );

  final tDriver = DriverEntity(
    id: 'd1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@test.com',
    phone: '12345',
    photo: '',
    role: 'driver',
    gender: 'male',
    country: 'EG',
    vehicleType: 'Car',
    vehicleNumber: '123',
    vehicleLicense: 'abc',
    nid: '111',
    nidImg: '',
  );

  final tDriverEmptyId = DriverEntity(
    id: '',
    firstName: 'No',
    lastName: 'ID',
    email: '',
    phone: '',
    photo: '',
    role: 'driver',
    gender: 'male',
    country: 'EG',
    vehicleType: 'Car',
    vehicleNumber: '123',
    vehicleLicense: '',
    nid: '',
    nidImg: '',
  );

  final tPosition = Position(
    latitude: 30.0,
    longitude: 31.0,
    timestamp: DateTime.now(),
    accuracy: 10,
    altitude: 10,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

  final tVehicle = VehicleEntity(
    id: 'v1',
    type: 'Car',
    image: 'car.png',
    createdAt: '',
    updatedAt: '',
  );

  setUpAll(() {
    provideDummy<BaseResponse<OrderEntity>>(SuccessResponse(data: tOrder));
    provideDummy<BaseResponse<DriverEntity>>(SuccessResponse(data: tDriver));
    provideDummy<BaseResponse<VehicleEntity>>(SuccessResponse(data: tVehicle));
  });

  setUp(() {
    mockStartOrder = MockStartOrderUseCase();
    mockFirebase = MockFirebaseOrderService();
    mockSession = MockSessionController();
    mockLocation = MockLocationService();
    mockGetProfile = MockGetDriverProfileUseCase();
    mockPrefs = MockSharedPreferences();
    mockGetVehicle = MockGetVehicleUseCase();
    mockActiveOrderService = MockActiveOrderFirestoreService();

    when(
      mockActiveOrderService.saveActiveOrder(any, any),
    ).thenAnswer((_) async {});

    useCase = AcceptOrderUseCase(
      mockStartOrder,
      mockFirebase,
      mockSession,
      mockLocation,
      mockGetProfile,
      mockPrefs,
      mockGetVehicle,
      mockActiveOrderService,
    );
  });

  group('AcceptOrderUseCase Additional Coverage', () {
    test(
      'returns ErrorResponse when location is null (GPS disabled)',
      () async {
        when(mockLocation.getCurrentLocation()).thenAnswer((_) async => null);

        final result = await useCase(tOrder);

        expect(result, isA<ErrorResponse<OrderEntity>>());
        final error = result as ErrorResponse<OrderEntity>;
        expect(error.errorMessage, contains('Location services'));
      },
    );

    test(
      'returns ErrorResponse when session user is null and profile fetch fails',
      () async {
        when(
          mockLocation.getCurrentLocation(),
        ).thenAnswer((_) async => tPosition);
        when(mockSession.user).thenReturn(null);
        when(mockGetProfile.call()).thenAnswer(
          (_) async => const ErrorResponse(errorMessage: 'not found'),
        );

        final result = await useCase(tOrder);

        expect(result, isA<ErrorResponse<OrderEntity>>());
        final error = result as ErrorResponse<OrderEntity>;
        expect(error.errorMessage, contains('Driver profile not found'));
      },
    );

    test(
      'fetches profile from API when session user is null but profile succeeds',
      () async {
        when(
          mockLocation.getCurrentLocation(),
        ).thenAnswer((_) async => tPosition);
        when(mockSession.user).thenReturn(null);
        when(
          mockGetProfile.call(),
        ).thenAnswer((_) async => SuccessResponse(data: tDriver));
        when(mockSession.saveUser(any)).thenReturn(null);
        when(
          mockFirebase.getUserDataByUserId(any),
        ).thenAnswer((_) async => {'userId': 'u1'});
        when(
          mockStartOrder.call(any),
        ).thenAnswer((_) async => SuccessResponse(data: tOrder));
        when(
          mockGetVehicle.call(any),
        ).thenAnswer((_) async => SuccessResponse(data: tVehicle));
        when(
          mockFirebase.uploadTrackingOrder(any, any),
        ).thenAnswer((_) async {});
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        final result = await useCase(tOrder);

        expect(result, isA<SuccessResponse<OrderEntity>>());
        verify(mockGetProfile.call()).called(1);
        verify(mockSession.saveUser(tDriver)).called(1);
      },
    );

    test('succeeds even when vehicle fetch fails (image is null)', () async {
      when(
        mockLocation.getCurrentLocation(),
      ).thenAnswer((_) async => tPosition);
      when(mockSession.user).thenReturn(tDriver);
      when(mockFirebase.getUserDataByUserId(any)).thenAnswer((_) async => null);
      when(
        mockStartOrder.call(any),
      ).thenAnswer((_) async => SuccessResponse(data: tOrder));
      when(mockGetVehicle.call(any)).thenAnswer(
        (_) async => const ErrorResponse(errorMessage: 'vehicle not found'),
      );
      when(mockFirebase.uploadTrackingOrder(any, any)).thenAnswer((_) async {});
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      final result = await useCase(tOrder);

      expect(result, isA<SuccessResponse<OrderEntity>>());
    });

    test('does NOT call saveActiveOrder when driverId is empty', () async {
      when(
        mockLocation.getCurrentLocation(),
      ).thenAnswer((_) async => tPosition);
      when(mockSession.user).thenReturn(tDriverEmptyId);
      when(mockFirebase.getUserDataByUserId(any)).thenAnswer((_) async => null);
      when(
        mockStartOrder.call(any),
      ).thenAnswer((_) async => SuccessResponse(data: tOrder));
      when(
        mockGetVehicle.call(any),
      ).thenAnswer((_) async => const ErrorResponse(errorMessage: 'not found'));
      when(mockFirebase.uploadTrackingOrder(any, any)).thenAnswer((_) async {});
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      await useCase(tOrder);

      verifyNever(mockActiveOrderService.saveActiveOrder(any, any));
    });

    test(
      'post-API exception is swallowed, still returns SuccessResponse',
      () async {
        when(
          mockLocation.getCurrentLocation(),
        ).thenAnswer((_) async => tPosition);
        when(mockSession.user).thenReturn(tDriver);
        when(
          mockFirebase.getUserDataByUserId(any),
        ).thenAnswer((_) async => null);
        when(
          mockStartOrder.call(any),
        ).thenAnswer((_) async => SuccessResponse(data: tOrder));
        // Cause a crash in post-API ops
        when(mockGetVehicle.call(any)).thenThrow(Exception('unexpected crash'));

        final result = await useCase(tOrder);

        // Must still return success since startOrder succeeded
        expect(result, isA<SuccessResponse<OrderEntity>>());
      },
    );
  });
}
