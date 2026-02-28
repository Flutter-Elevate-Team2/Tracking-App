import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/order/domain/use_cases/get_all_driver_orders.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'my_orders_view_model_test.mocks.dart';

@GenerateMocks([GetAllDriverOrdersUseCase])
void main() {
  late MyOrdersViewModel viewModel;
  late MockGetAllDriverOrdersUseCase mockUseCase;

  // Setup Dummy for Mockito to handle the Generic return type
  provideDummy<BaseResponse<MyOrdersState>>(
    SuccessResponse(data: const MyOrdersState()),
  );

  setUp(() {
    mockUseCase = MockGetAllDriverOrdersUseCase();
    viewModel = MyOrdersViewModel(mockUseCase);
  });

  tearDown(() => viewModel.close());

  const tOrdersState = MyOrdersState(
    allOrders: [],
    completedOrdersCount: 10,
    canceledOrdersCount: 5,
  );

  group('MyOrdersViewModel 100% Coverage Tests', () {

    test('Initial state should be MyOrdersState() with default values', () {
      expect(viewModel.state, const MyOrdersState());
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, isNull);
    });

    blocTest<MyOrdersViewModel, MyOrdersState>(
      'Should emit [Loading, Success] and clear error when fetching succeeds',
      build: () {
        when(mockUseCase.call()).thenAnswer((_) async => SuccessResponse(data: tOrdersState));
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetDriverOrdersEvent()),
      expect: () => [
        // 1. First state: Loading is true, Error is null
        const MyOrdersState(isLoading: true, errorMessage: null),
        // 2. Second state: Loading is false, Data is populated
        tOrdersState.copyWith(isLoading: false),
      ],
      verify: (_) => verify(mockUseCase.call()).called(1),
    );

    blocTest<MyOrdersViewModel, MyOrdersState>(
      'Should emit [Loading, Error] when fetching fails',
      build: () {
        when(mockUseCase.call()).thenAnswer(
              (_) async => ErrorResponse(errorMessage: 'Server Failure'),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetDriverOrdersEvent()),
      expect: () => [
        const MyOrdersState(isLoading: true),
        const MyOrdersState(isLoading: false, errorMessage: 'Server Failure'),
      ],
    );

    blocTest<MyOrdersViewModel, MyOrdersState>(
      'Should clear previous error message when retrying a request',
      // Start with an error state already present
      seed: () => const MyOrdersState(errorMessage: 'Old Error'),
      build: () {
        when(mockUseCase.call()).thenAnswer((_) async => SuccessResponse(data: tOrdersState));
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetDriverOrdersEvent()),
      expect: () => [
        // Crucial: check that isLoading becomes true AND errorMessage becomes NULL immediately
        const MyOrdersState(isLoading: true, errorMessage: null),
        tOrdersState.copyWith(isLoading: false, errorMessage: null),
      ],
    );
  });
}
