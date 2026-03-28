import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/order/domain/entities/response/update_order_response_entity.dart';
import 'package:tracking_app/Features/order/domain/repo/order_repo_contract.dart';
import 'package:tracking_app/Features/order/domain/use_cases/update_order_state_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'update_Order_state_use_case_test.mocks.dart';



@GenerateMocks([OrderRepoContract])
void main() {
  late UpdateOrderStateUseCase useCase;
  late MockOrderRepoContract mockRepo;

  setUp(() {
    // إعداد الـ Dummy Data للـ SuccessResponse
    provideDummy<BaseResponse<UpdateOrderResponseEntity>>(
      SuccessResponse(
        data: UpdateOrderResponseEntity(message: "dummy"),
      ),
    );

    mockRepo = MockOrderRepoContract();
    useCase = UpdateOrderStateUseCase(mockRepo);
  });

  const tId = "123";
  const tOrderState = "delivered";
  final tUpdateResponseEntity = UpdateOrderResponseEntity(message: "Order updated");

  test(
    'should return SuccessResponse when repo updates order state successfully',
        () async {
      // Arrange
      when(mockRepo.updateOrderState(any, any))
          .thenAnswer((_) async => SuccessResponse(data: tUpdateResponseEntity));

      // Act
      final result = await useCase(tId, tOrderState);

      // Assert
      expect(result, isA<SuccessResponse<UpdateOrderResponseEntity>>());
      expect((result as SuccessResponse).data, tUpdateResponseEntity);
      // التأكد من تمرير الـ Parameters الصحيحة للـ repo
      verify(mockRepo.updateOrderState(tId, tOrderState)).called(1);
    },
  );

  test(
    'should return ErrorResponse when repo fails to update order state',
        () async {
      // Arrange
      when(mockRepo.updateOrderState(any, any))
          .thenAnswer((_) async => ErrorResponse(errorMessage: 'Update Failed'));

      // Act
      final result = await useCase(tId, tOrderState);

      // Assert
      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).errorMessage, 'Update Failed');
      verify(mockRepo.updateOrderState(tId, tOrderState)).called(1);
    },
  );
}