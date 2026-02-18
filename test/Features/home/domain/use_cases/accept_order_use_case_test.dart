import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/use_cases/accept_order_use_case.dart';
import 'package:tracking_app/Features/home/domain/use_cases/start_order_use_case.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_driver_profile_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/location_service.dart';

import 'accept_order_use_case_test.mocks.dart';

@GenerateMocks([
  StartOrderUseCase,
  FirebaseOrderService,
  SessionController,
  LocationService,
  GetDriverProfileUseCase,
  SharedPreferences,
])
void main() {
  late MockStartOrderUseCase mockStartOrder;
  late MockFirebaseOrderService mockFirebase;
  late MockSessionController mockSession;
  late MockLocationService mockLocation;
  late MockGetDriverProfileUseCase mockGetProfile;
  late MockSharedPreferences mockPrefs;
  late AcceptOrderUseCase useCase;

  final tOrder = OrderEntity(id: '123', orderNumber: '#1');
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

  setUpAll(() {
    provideDummy<BaseResponse<OrderEntity>>(SuccessResponse(data: tOrder));
    provideDummy<BaseResponse<List<OrderEntity>>>(SuccessResponse(data: []));
    provideDummy<BaseResponse<DriverEntity>>(SuccessResponse(data: tDriver));
  });

  setUp(() {
    mockStartOrder = MockStartOrderUseCase();
    mockFirebase = MockFirebaseOrderService();
    mockSession = MockSessionController();
    mockLocation = MockLocationService();
    mockGetProfile = MockGetDriverProfileUseCase();
    mockPrefs = MockSharedPreferences();

    useCase = AcceptOrderUseCase(
      mockStartOrder,
      mockFirebase,
      mockSession,
      mockLocation,
      mockGetProfile,
      mockPrefs,
    );
  });

  group('AcceptOrderUseCase Tests', () {
    test('successfully accepts order and updates all services', () async {
      // Stubbing
      when(
        mockFirebase.getUserDataByOrderId(any),
      ).thenAnswer((_) async => {'userId': 'u1', 'deviceToken': 't1'});
      when(
        mockStartOrder.call(any),
      ).thenAnswer((_) async => SuccessResponse(data: tOrder));
      when(mockSession.user).thenReturn(tDriver);
      when(
        mockGetProfile.call(),
      ).thenAnswer((_) async => SuccessResponse(data: tDriver));
      when(
        mockLocation.getCurrentLocation(),
      ).thenAnswer((_) async => tPosition);
      when(
        mockFirebase.uploadTrackingOrder(any, any),
      ).thenAnswer((_) async => {});
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      // Action
      final result = await useCase(tOrder);

      // Verify
      expect(result, isA<SuccessResponse<OrderEntity>>());
      verify(mockFirebase.getUserDataByOrderId('123')).called(1);
      verify(mockStartOrder.call('123')).called(1);
      verify(mockFirebase.uploadTrackingOrder('123', any)).called(1);
      verify(
        mockPrefs.setString(ApiConstants.currentOrderIdKey, '123'),
      ).called(1);
    });

    test('failure to start order stops execution', () async {
      // Stubbing
      when(
        mockFirebase.getUserDataByOrderId(any),
      ).thenAnswer((_) async => {'userId': 'u1'});
      when(
        mockStartOrder.call(any),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'api error'));

      // Action
      final result = await useCase(tOrder);

      // Verify
      expect(result, isA<ErrorResponse<OrderEntity>>());
      verifyNever(mockFirebase.uploadTrackingOrder(any, any));
      verifyNever(mockPrefs.setString(any, any));
    });
  });
}
