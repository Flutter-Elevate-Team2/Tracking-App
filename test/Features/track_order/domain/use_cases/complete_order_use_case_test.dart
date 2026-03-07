import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/repo/track_order_repo_contract.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/complete_order_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'complete_order_use_case_test.mocks.dart';

@GenerateMocks([TrackOrderRepoContract])
void main() {
  provideDummy<BaseResponse<CompleteOrderEntity>>(
    const ErrorResponse(errorMessage: 'dummy'),
  );
  late CompleteOrderUseCase useCase;
  late MockTrackOrderRepoContract mockRepo;

  setUp(() {
    mockRepo = MockTrackOrderRepoContract();
    useCase = CompleteOrderUseCase(mockRepo);
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
  });
}
