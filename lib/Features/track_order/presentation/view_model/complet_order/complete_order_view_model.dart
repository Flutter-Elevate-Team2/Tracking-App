import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/complete_order_use_case.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_events.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_state.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';

@injectable
class CompleteOrderViewModel extends Cubit<CompleteOrderState> {
  final CompleteOrderUseCase _completeOrderUseCase;
  final ActiveOrderFirestoreService _activeOrderFirestoreService;

  CompleteOrderViewModel(
    this._completeOrderUseCase,
    this._activeOrderFirestoreService,
  ) : super(const CompleteOrderState());

  void doIntent(CompleteOrderEvents event) {
    switch (event) {
      case CompleteOrderEvent(orderId: final orderId):
        completeOrder(orderId);
        break;
    }
  }

  Future<void> completeOrder(String orderId) async {
    // 1. Unconditionally release the driver from lock-in immediately
    final prefs = await SharedPreferences.getInstance();
    final driverId = prefs.getString(ApiConstants.driverIdKey) ?? '';
    if (driverId.isNotEmpty) {
      await _activeOrderFirestoreService.clearActiveOrder(driverId);
    }
    await prefs.remove(ApiConstants.currentOrderIdKey);

    // 2. Start API loading state
    emit(
      state.copyWith(
        completeOrderState: const BaseState<CompleteOrderEntity>(
          isLoading: true,
        ),
      ),
    );
    try {
      final response = await _completeOrderUseCase(orderId);
      switch (response) {
        case SuccessResponse<CompleteOrderEntity>():
          emit(
            state.copyWith(
              completeOrderState: BaseState<CompleteOrderEntity>(
                isLoading: false,
                data: response.data,
              ),
            ),
          );
          break;
        case ErrorResponse<CompleteOrderEntity>():
          emit(
            state.copyWith(
              completeOrderState: BaseState<CompleteOrderEntity>(
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
            ),
          );
          break;
      }
    } catch (e) {
      emit(
        state.copyWith(
          completeOrderState: BaseState<CompleteOrderEntity>(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }
}
