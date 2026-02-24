import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';
import 'package:tracking_app/Features/order/domain/repo/order_repo_contract.dart';
import 'package:tracking_app/Features/order/domain/use_cases/get_all_driver_orders.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'get_all_driver_orders_test.mocks.dart';

@GenerateMocks([OrderRepoContract])
void main() {
  late GetAllDriverOrdersUseCase useCase;
  late MockOrderRepoContract mockRepo;

  setUp(() {
    // إعداد الـ Dummy Data عشان Mockito يقدر يتعامل مع الـ Generic BaseResponse
    provideDummy<BaseResponse<DriverOrdersResponseEntity>>(
      SuccessResponse(
        data: DriverOrdersResponseEntity(message: "dummy", orders: []),
      ),
    );

    mockRepo = MockOrderRepoContract();
    useCase = GetAllDriverOrdersUseCase(mockRepo);
  });

  final tResponseEntity = DriverOrdersResponseEntity(
    message: "Success",
    orders: [], // ممكن تضيف Mock Orders هنا لو حبيت
  );

  test(
    'should return SuccessResponse<DriverOrdersResponseEntity> when repo succeeds',
        () async {
      // Arrange
      when(mockRepo.getAllDriverOrders())
          .thenAnswer((_) async => SuccessResponse(data: tResponseEntity));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<SuccessResponse<DriverOrdersResponseEntity>>());
      expect((result as SuccessResponse).data, tResponseEntity);
      verify(mockRepo.getAllDriverOrders()).called(1);
      verifyNoMoreInteractions(mockRepo);
    },
  );

  test(
    'should return ErrorResponse when repo fails',
        () async {
      // Arrange
      when(mockRepo.getAllDriverOrders())
          .thenAnswer((_) async => ErrorResponse(errorMessage: 'Server Error'));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).errorMessage, 'Server Error');
      verify(mockRepo.getAllDriverOrders()).called(1);
    },
  );
}