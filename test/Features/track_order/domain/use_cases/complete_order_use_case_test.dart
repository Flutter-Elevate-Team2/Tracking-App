import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/repo/track_order_repo_contract.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/complete_order_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';

import 'complete_order_use_case_test.mocks.dart';

@GenerateMocks([TrackOrderRepoContract, ActiveOrderFirestoreService])
void main() {
  provideDummy<BaseResponse<CompleteOrderEntity>>(
    const ErrorResponse(errorMessage: 'dummy'),
  );
  late CompleteOrderUseCase useCase;
  late MockTrackOrderRepoContract mockRepo;
  late MockActiveOrderFirestoreService mockFirestoreService;

  setUp(() {
    mockRepo = MockTrackOrderRepoContract();
    mockFirestoreService = MockActiveOrderFirestoreService();
    useCase = CompleteOrderUseCase(mockRepo, mockFirestoreService);
  });

  group('CompleteOrderUseCase Test', () {
    const orderId = '123';
    final tEntity = CompleteOrderEntity(
      message: 'Success',
      orderId: '123',
      orderNumber: '1',
      state: 'completed',
      totalPrice: 100.0,
      paymentType: 'cash',
    );

    test(
      'should call changeOrderState on repository with correct orderId',
      () async {
        // Arrange
        when(
          mockRepo.changeOrderState(orderId),
        ).thenAnswer((_) async => SuccessResponse(data: tEntity));

        // Act
        final result = await useCase(orderId);

        // Assert
        expect(result, isA<SuccessResponse<CompleteOrderEntity>>());
        expect((result as SuccessResponse).data, tEntity);
        verify(mockRepo.changeOrderState(orderId)).called(1);
      },
    );

    test(
      'should return ErrorResponse when repository succeeds with error',
      () async {
        // Arrange
        when(
          mockRepo.changeOrderState(orderId),
        ).thenAnswer((_) async => const ErrorResponse(errorMessage: 'Failure'));

        // Act
        final result = await useCase(orderId);

        // Assert
        expect(result, isA<ErrorResponse<CompleteOrderEntity>>());
        expect((result as ErrorResponse).errorMessage, 'Failure');
        verify(mockRepo.changeOrderState(orderId)).called(1);
      },
    );
  });
}
