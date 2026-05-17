import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:tracking_app/Features/home/domain/use_cases/start_order_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'start_order_use_case_test.mocks.dart';

@GenerateMocks([HomeRepoContract])
void main() {
  late MockHomeRepoContract mockRepo;
  late StartOrderUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<OrderEntity>>(
      SuccessResponse(
        data: const OrderEntity(id: '1', orderNumber: '#1'),
      ),
    );
  });

  setUp(() {
    mockRepo = MockHomeRepoContract();
    useCase = StartOrderUseCase(mockRepo);
  });

  group('StartOrderUseCase Tests', () {
    test('should return SuccessResponse from the repository', () async {
      const tOrder = OrderEntity(id: '1', orderNumber: '#1');
      when(
        mockRepo.startOrder(any),
      ).thenAnswer((_) async => SuccessResponse(data: tOrder));

      final result = await useCase.call('1');

      expect(result, isA<SuccessResponse<OrderEntity>>());
      expect((result as SuccessResponse<OrderEntity>).data, tOrder);
      verify(mockRepo.startOrder('1')).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ErrorResponse from the repository', () async {
      const errorMessage = 'An error occurred';
      when(
        mockRepo.startOrder(any),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

      final result = await useCase.call('1');

      expect(result, isA<ErrorResponse<OrderEntity>>());
      expect((result as ErrorResponse<OrderEntity>).errorMessage, errorMessage);
      verify(mockRepo.startOrder('1')).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
