import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:tracking_app/Features/home/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'get_pending_orders_use_case_test.mocks.dart';

@GenerateMocks([HomeRepoContract])
void main() {
  late MockHomeRepoContract mockRepo;
  late GetPendingOrdersUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<OrderEntity>>>(SuccessResponse(data: []));
  });

  setUp(() {
    mockRepo = MockHomeRepoContract();
    useCase = GetPendingOrdersUseCase(mockRepo);
  });

  group('GetPendingOrdersUseCase Tests', () {
    test('should return SuccessResponse from the repository', () async {
      final tOrders = [const OrderEntity(id: '1', orderNumber: '#1')];
      when(
        mockRepo.getPendingOrders(),
      ).thenAnswer((_) async => SuccessResponse(data: tOrders));

      final result = await useCase.call();

      expect(result, isA<SuccessResponse<List<OrderEntity>>>());
      expect((result as SuccessResponse<List<OrderEntity>>).data, tOrders);
      verify(mockRepo.getPendingOrders()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ErrorResponse from the repository', () async {
      const errorMessage = 'An error occurred';
      when(
        mockRepo.getPendingOrders(),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

      final result = await useCase.call();

      expect(result, isA<ErrorResponse<List<OrderEntity>>>());
      expect(
        (result as ErrorResponse<List<OrderEntity>>).errorMessage,
        errorMessage,
      );
      verify(mockRepo.getPendingOrders()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
