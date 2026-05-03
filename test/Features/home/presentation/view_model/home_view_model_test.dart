import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/use_cases/accept_order_use_case.dart';
import 'package:tracking_app/Features/home/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([GetPendingOrdersUseCase, AcceptOrderUseCase])
void main() {
  late MockGetPendingOrdersUseCase mockGetOrders;
  late MockAcceptOrderUseCase mockAcceptOrder;
  late HomeViewModel viewModel;

  final tOrder = OrderEntity(id: '1', orderNumber: '#1', totalPrice: 100);
  final tOrders = [tOrder];

  setUpAll(() {
    provideDummy<BaseResponse<HomeOrdersEntity>>(
      SuccessResponse(data: const HomeOrdersEntity(orders: [], totalPages: 1)),
    );
    provideDummy<BaseResponse<OrderEntity>>(SuccessResponse(data: tOrder));
  });

  setUp(() {
    mockGetOrders = MockGetPendingOrdersUseCase();
    mockAcceptOrder = MockAcceptOrderUseCase();
    viewModel = HomeViewModel(mockGetOrders, mockAcceptOrder);
  });

  group('HomeViewModel Tests', () {
    test('initial state should be HomeState', () {
      expect(viewModel.state, const HomeState());
    });

    blocTest<HomeViewModel, HomeState>(
      'emits [loading, success] when GetPendingOrdersEvent is successful (reverse pagination)',
      build: () {
        // Page 1 to get metadata
        when(mockGetOrders.call(1)).thenAnswer(
          (_) async => const SuccessResponse(
            data: HomeOrdersEntity(orders: [], totalPages: 2),
          ),
        );
        // Page 2 (last page) as entry point
        when(mockGetOrders.call(2)).thenAnswer(
          (_) async => SuccessResponse(
            data: HomeOrdersEntity(orders: tOrders, totalPages: 2),
          ),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent()),
      expect: () => [
        const HomeState(ordersState: BaseState(isLoading: true)),
        HomeState(
          ordersState: BaseState(
            isLoading: false,
            data: tOrders.reversed.toList(),
          ),
          currentPage: 2,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<HomeViewModel, HomeState>(
      'emits [loading, error] when GetPendingOrdersEvent fails at initial call',
      build: () {
        when(
          mockGetOrders.call(1),
        ).thenAnswer((_) async => const ErrorResponse(errorMessage: 'error'));
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent()),
      expect: () => [
        const HomeState(ordersState: BaseState(isLoading: true)),
        const HomeState(
          ordersState: BaseState(isLoading: false, errorMessage: 'error'),
        ),
      ],
    );

    blocTest<HomeViewModel, HomeState>(
      'emits [acceptLoading, acceptSuccess + updateOrders] when AcceptOrderEvent is successful',
      build: () {
        when(
          mockAcceptOrder.call(any),
        ).thenAnswer((_) async => SuccessResponse(data: tOrder));
        return viewModel;
      },
      seed: () => HomeState(ordersState: BaseState(data: tOrders)),
      act: (bloc) => bloc.doIntent(AcceptOrderEvent(tOrder)),
      expect: () => [
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(isLoading: true),
        ),
        HomeState(
          ordersState: const BaseState(data: []),
          acceptOrderState: BaseState(isLoading: false, data: tOrder),
        ),
      ],
    );

    blocTest<HomeViewModel, HomeState>(
      'emits [acceptLoading, acceptError] when AcceptOrderEvent fails',
      build: () {
        when(
          mockAcceptOrder.call(any),
        ).thenAnswer((_) async => const ErrorResponse(errorMessage: 'error'));
        return viewModel;
      },
      seed: () => HomeState(ordersState: BaseState(data: tOrders)),
      act: (bloc) => bloc.doIntent(AcceptOrderEvent(tOrder)),
      expect: () => [
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(isLoading: true),
        ),
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(
            isLoading: false,
            errorMessage: 'error',
          ),
        ),
      ],
    );

    blocTest<HomeViewModel, HomeState>(
      'removes order from list when RejectOrderEvent is added',
      build: () => viewModel,
      seed: () => HomeState(ordersState: BaseState(data: tOrders)),
      act: (bloc) => bloc.doIntent(RejectOrderEvent(tOrder.id)),
      expect: () => [const HomeState(ordersState: BaseState(data: []))],
    );
  });
}
