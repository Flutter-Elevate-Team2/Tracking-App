import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

import 'home_view_model_test.mocks.dart';

void main() {
  late MockGetPendingOrdersUseCase mockGetOrders;
  late MockAcceptOrderUseCase mockAcceptOrder;

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
  });

  group('HomeViewModel Additional Coverage Tests', () {
    // ── EARLY-EXIT GUARDS ──────────────────────────────────────────────────
    // When hasReachedMax=true the first emit (clearAccept) produces the SAME
    // state as the seed (acceptOrderState is already BaseState()), so Cubit
    // deduplicates and nothing is emitted at all.
    blocTest<HomeViewModel, HomeState>(
      'getPendingOrders: skips if hasReachedMax and not refresh – no state change',
      build: () => HomeViewModel(mockGetOrders, mockAcceptOrder),
      seed: () => const HomeState(hasReachedMax: true),
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent()),
      expect: () =>
          <HomeState>[], // deduplicated — bloc won't re-emit same state
    );

    blocTest<HomeViewModel, HomeState>(
      'getPendingOrders: skips if isPaginationLoading – no state change',
      build: () => HomeViewModel(mockGetOrders, mockAcceptOrder),
      seed: () => const HomeState(isPaginationLoading: true),
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent()),
      expect: () =>
          <HomeState>[], // deduplicated — bloc won't re-emit same state
    );

    // ── PAGINATION PATH ────────────────────────────────────────────────────
    // When ordersState already has data (not first load), the vm emits
    // isPaginationLoading=true then the success/error state.
    // The "clearAccept" emit equals the seed so it is deduplicated (no emission).
    blocTest<HomeViewModel, HomeState>(
      'getPendingOrders pagination: emits isPaginationLoading then success',
      build: () {
        when(mockGetOrders.call(currentPage: 1, isRefresh: false)).thenAnswer(
          (_) async => SuccessResponse(
            data: HomeOrdersEntity(
              orders: [const OrderEntity(id: '2')],
              totalPages: 3,
              currentPage: 2,
            ),
          ),
        );
        return HomeViewModel(mockGetOrders, mockAcceptOrder);
      },
      seed: () => HomeState(
        ordersState: BaseState(data: tOrders),
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent()),
      expect: () => [
        // isPaginationLoading=true (clearAccept is deduplicated)
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(),
          isPaginationLoading: true,
          hasReachedMax: false,
        ),
        // success: merged orders, isPaginationLoading=false
        isA<HomeState>(),
      ],
    );

    blocTest<HomeViewModel, HomeState>(
      'getPendingOrders pagination: error only sets isPaginationLoading=false',
      build: () {
        when(mockGetOrders.call(currentPage: 1, isRefresh: false)).thenAnswer(
          (_) async => const ErrorResponse(errorMessage: 'pagination error'),
        );
        return HomeViewModel(mockGetOrders, mockAcceptOrder);
      },
      seed: () => HomeState(
        ordersState: BaseState(data: tOrders),
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent()),
      expect: () => [
        // isPaginationLoading=true (clearAccept is deduplicated)
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(),
          isPaginationLoading: true,
          hasReachedMax: false,
        ),
        // isPaginationLoading=false (ordersState unchanged on pagination error)
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(),
          isPaginationLoading: false,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<HomeViewModel, HomeState>(
      'getPendingOrders throws exception during pagination: isPaginationLoading=false',
      build: () {
        when(
          mockGetOrders.call(currentPage: 1, isRefresh: false),
        ).thenThrow(Exception('network error'));
        return HomeViewModel(mockGetOrders, mockAcceptOrder);
      },
      seed: () => HomeState(
        ordersState: BaseState(data: tOrders),
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent()),
      expect: () => [
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(),
          isPaginationLoading: true,
          hasReachedMax: false,
        ),
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(),
          isPaginationLoading: false,
          hasReachedMax: false,
        ),
      ],
    );

    // ── FIRST-LOAD EXCEPTION PATH ──────────────────────────────────────────
    blocTest<HomeViewModel, HomeState>(
      'getPendingOrders throws exception on first load: emits error state',
      build: () {
        when(
          mockGetOrders.call(currentPage: 1, isRefresh: false),
        ).thenThrow(Exception('network error'));
        return HomeViewModel(mockGetOrders, mockAcceptOrder);
      },
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent()),
      expect: () => [
        const HomeState(acceptOrderState: BaseState()),
        const HomeState(
          ordersState: BaseState(isLoading: true),
          acceptOrderState: BaseState(),
          hasReachedMax: false,
        ),
        isA<HomeState>(), // error state with errorMessage
      ],
    );

    // ── ISREFRESH=TRUE ─────────────────────────────────────────────────────
    // With seed currentPage=3, the vm calls call(currentPage: 3, isRefresh: true)
    blocTest<HomeViewModel, HomeState>(
      'getPendingOrders with isRefresh=true fetches fresh data from current page',
      build: () {
        when(mockGetOrders.call(currentPage: 3, isRefresh: true)).thenAnswer(
          (_) async => SuccessResponse(
            data: HomeOrdersEntity(
              orders: tOrders,
              totalPages: 1,
              currentPage: 1,
            ),
          ),
        );
        return HomeViewModel(mockGetOrders, mockAcceptOrder);
      },
      seed: () => HomeState(
        ordersState: BaseState(data: [const OrderEntity(id: 'old')]),
        currentPage: 3,
      ),
      act: (bloc) => bloc.doIntent(GetPendingOrdersEvent(isRefresh: true)),
      expect: () => [
        // clearAccept is deduplicated — seed's acceptOrderState is already
        // equivalent to BaseState(), so no extra emission occurs.
        isA<
          HomeState
        >(), // loading with refresh=true (keeps old data during load)
        isA<HomeState>(), // success with fresh data
      ],
    );

    // ── ACCEPT ORDER EXCEPTION ────────────────────────────────────────────
    blocTest<HomeViewModel, HomeState>(
      'acceptOrder throws exception: emits error acceptOrderState',
      build: () {
        when(mockAcceptOrder.call(any)).thenThrow(Exception('accept failed'));
        return HomeViewModel(mockGetOrders, mockAcceptOrder);
      },
      seed: () => HomeState(ordersState: BaseState(data: tOrders)),
      act: (bloc) => bloc.doIntent(AcceptOrderEvent(tOrder)),
      expect: () => [
        HomeState(
          ordersState: BaseState(data: tOrders),
          acceptOrderState: const BaseState(isLoading: true),
          acceptingOrderId: '1',
        ),
        isA<HomeState>(), // error state with message
      ],
    );
  });
}
