import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/repo/track_order_repo_contract.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/complete_order_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

import 'complete_order_use_case_test.mocks.dart';

@GenerateMocks([
  TrackOrderRepoContract,
  ActiveOrderFirestoreService,
  SharedPreferences,
])
void main() {
  late CompleteOrderUseCase useCase;
  late MockTrackOrderRepoContract mockRepo;
  late MockActiveOrderFirestoreService mockFirestoreService;
  late FakeFirebaseFirestore fakeFirestore;
  late MockSharedPreferences mockPrefs;

  final tEntity = CompleteOrderEntity(
    message: 'Success',
    orderId: '123',
    orderNumber: '1',
    state: 'completed',
    totalPrice: 100.0,
    paymentType: 'cash',
  );

  setUpAll(() {
    provideDummy<BaseResponse<CompleteOrderEntity>>(
      SuccessResponse(data: tEntity),
    );
  });

  setUp(() {
    mockRepo = MockTrackOrderRepoContract();
    mockFirestoreService = MockActiveOrderFirestoreService();
    fakeFirestore = FakeFirebaseFirestore();
    mockPrefs = MockSharedPreferences();

    useCase = CompleteOrderUseCase(
      mockRepo,
      mockFirestoreService,
      fakeFirestore,
      mockPrefs,
    );
  });

  group('CompleteOrderUseCase 100% Coverage Test', () {
    const orderId = '123';
    const driverId = 'D789';

    test('Full Success Path: Should update Firestore and Prefs', () async {
      await fakeFirestore.collection('active_orders').doc(orderId).set({
        'status': 'pending',
      });

      when(
        mockRepo.changeOrderState(orderId),
      ).thenAnswer((_) async => SuccessResponse(data: tEntity));
      when(mockPrefs.getString(ApiConstants.driverIdKey)).thenReturn(driverId);
      when(mockPrefs.remove(any)).thenAnswer((_) async => true);

      final result = await useCase(orderId);

      expect(result, isA<SuccessResponse<CompleteOrderEntity>>());
      final doc = await fakeFirestore
          .collection('active_orders')
          .doc(orderId)
          .get();
      expect(doc.data()?['status'], 'completed');

      verify(mockRepo.changeOrderState(orderId)).called(1);
      verify(mockFirestoreService.clearActiveOrder(driverId)).called(1);
      verify(mockPrefs.remove(ApiConstants.currentOrderIdKey)).called(1);
    });

    test(
      'Branch Coverage: Should skip clearActiveOrder if driverId is empty',
      () async {
        await fakeFirestore.collection('active_orders').doc(orderId).set({
          'status': 'pending',
        });

        when(
          mockRepo.changeOrderState(orderId),
        ).thenAnswer((_) async => SuccessResponse(data: tEntity));
        when(mockPrefs.getString(ApiConstants.driverIdKey)).thenReturn('');

        await useCase(orderId);

        verifyNever(mockFirestoreService.clearActiveOrder(any));
      },
    );

    test(
      'Catch Block Coverage: Should handle errors in side effects',
      () async {
        when(
          mockRepo.changeOrderState(orderId),
        ).thenAnswer((_) async => SuccessResponse(data: tEntity));
        when(mockPrefs.getString(any)).thenThrow(Exception("Simulated Error"));

        final result = await useCase(orderId);

        expect(result, isA<SuccessResponse>());
      },
    );

    test('Failure Path: Should not execute sync logic if API fails', () async {
      when(
        mockRepo.changeOrderState(orderId),
      ).thenAnswer((_) async => const ErrorResponse(errorMessage: 'Fail'));

      final result = await useCase(orderId);

      expect(result, isA<ErrorResponse>());
      verifyNever(mockPrefs.getString(any));
      verifyNever(mockFirestoreService.clearActiveOrder(any));
    });
  });
}
