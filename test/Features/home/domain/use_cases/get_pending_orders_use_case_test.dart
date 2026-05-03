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
    provideDummy<BaseResponse<HomeOrdersEntity>>(
      SuccessResponse(data: const HomeOrdersEntity(orders: [], totalPages: 1)),
    );
  });

  setUp(() {
    mockRepo = MockHomeRepoContract();
    useCase = GetPendingOrdersUseCase(mockRepo);
  });

  group('GetPendingOrdersUseCase Tests', () {
    test('should return SuccessResponse from the repository', () async {
      const tOrders = [OrderEntity(id: '1', orderNumber: '#1')];
      const tHomeOrders = HomeOrdersEntity(orders: tOrders, totalPages: 1);
      when(
        mockRepo.getPendingOrders(1),
      ).thenAnswer((_) async => SuccessResponse(data: tHomeOrders));

      final result = await useCase.call(1);

      expect(result, isA<SuccessResponse<HomeOrdersEntity>>());
      expect((result as SuccessResponse<HomeOrdersEntity>).data, tHomeOrders);
      verify(mockRepo.getPendingOrders(1)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ErrorResponse from the repository', () async {
      const errorMessage = 'An error occurred';
      when(
        mockRepo.getPendingOrders(1),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

      final result = await useCase.call(1);

      expect(result, isA<ErrorResponse<HomeOrdersEntity>>());
      expect(
        (result as ErrorResponse<HomeOrdersEntity>).errorMessage,
        errorMessage,
      );
      verify(mockRepo.getPendingOrders(1)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
