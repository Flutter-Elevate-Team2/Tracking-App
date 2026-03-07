import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/complete_order_use_case.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_events.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_view_model.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

import 'complete_order_view_model_test.mocks.dart';

@GenerateMocks([CompleteOrderUseCase])
void main() {
  provideDummy<BaseResponse<CompleteOrderEntity>>(
    const ErrorResponse(errorMessage: 'dummy'),
  );
  late CompleteOrderViewModel viewModel;
  late MockCompleteOrderUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockCompleteOrderUseCase();
    viewModel = CompleteOrderViewModel(mockUseCase);
  });

  group('CompleteOrderViewModel Test', () {
    const orderId = '123';
    final tEntity = CompleteOrderEntity(
      message: 'Success',
      orderId: '123',
      orderNumber: '1',
      state: 'completed',
      totalPrice: 100.0,
      paymentType: 'cash',
    );

    test('initial state should be CompleteOrderState()', () {
      expect(viewModel.state, const CompleteOrderState());
    });

    blocTest<CompleteOrderViewModel, CompleteOrderState>(
      'emit loading and then success when completeOrder succeeds',
      build: () {
        when(
          mockUseCase(orderId),
        ).thenAnswer((_) async => SuccessResponse(data: tEntity));
        return viewModel;
      },
      act: (cubit) => cubit.completeOrder(orderId),
      expect: () => [
        const CompleteOrderState(
          completeOrderState: BaseState<CompleteOrderEntity>(isLoading: true),
        ),
        CompleteOrderState(
          completeOrderState: BaseState<CompleteOrderEntity>(
            isLoading: false,
            data: tEntity,
          ),
        ),
      ],
      verify: (_) {
        verify(mockUseCase(orderId)).called(1);
      },
    );

    blocTest<CompleteOrderViewModel, CompleteOrderState>(
      'emit loading and then error when completeOrder fails',
      build: () {
        when(
          mockUseCase(orderId),
        ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Error'));
        return viewModel;
      },
      act: (cubit) => cubit.completeOrder(orderId),
      expect: () => [
        const CompleteOrderState(
          completeOrderState: BaseState<CompleteOrderEntity>(isLoading: true),
        ),
        const CompleteOrderState(
          completeOrderState: BaseState<CompleteOrderEntity>(
            isLoading: false,
            errorMessage: 'Error',
          ),
        ),
      ],
    );

    blocTest<CompleteOrderViewModel, CompleteOrderState>(
      'emit loading and then error when completeOrder throws exception',
      build: () {
        when(mockUseCase(orderId)).thenThrow(Exception('Exception'));
        return viewModel;
      },
      act: (cubit) => cubit.completeOrder(orderId),
      expect: () => [
        const CompleteOrderState(
          completeOrderState: BaseState<CompleteOrderEntity>(isLoading: true),
        ),
        const CompleteOrderState(
          completeOrderState: BaseState<CompleteOrderEntity>(
            isLoading: false,
            errorMessage: 'Exception: Exception',
          ),
        ),
      ],
    );

    blocTest<CompleteOrderViewModel, CompleteOrderState>(
      'doIntent should trigger completeOrder when CompleteOrderEvent is received',
      build: () {
        when(
          mockUseCase(orderId),
        ).thenAnswer((_) async => SuccessResponse(data: tEntity));
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(CompleteOrderEvent(orderId: orderId)),
      expect: () => [
        const CompleteOrderState(
          completeOrderState: BaseState<CompleteOrderEntity>(isLoading: true),
        ),
        CompleteOrderState(
          completeOrderState: BaseState<CompleteOrderEntity>(
            isLoading: false,
            data: tEntity,
          ),
        ),
      ],
    );
  });
}
