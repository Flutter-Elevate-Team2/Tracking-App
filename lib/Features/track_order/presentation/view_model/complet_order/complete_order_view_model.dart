import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/complete_order_use_case.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_events.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_state.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

@injectable
class CompleteOrderViewModel extends Cubit<CompleteOrderState> {
  final CompleteOrderUseCase _completeOrderUseCase;

  CompleteOrderViewModel(this._completeOrderUseCase) : super(const CompleteOrderState());

  void doIntent(CompleteOrderEvents event) {
    switch (event) {
      case CompleteOrderEvent(orderId: final orderId):
        completeOrder(orderId);
        break;
    }
  }

  Future<void> completeOrder(String orderId) async {
    emit(state.copyWith(completeOrderState: const BaseState<CompleteOrderEntity>(isLoading: true)));
    try {
      final response = await _completeOrderUseCase(orderId);
      switch(response){
        case SuccessResponse<CompleteOrderEntity>():
          emit(state.copyWith(completeOrderState: BaseState<CompleteOrderEntity>(isLoading: false, data:response.data)));
          break;
        case ErrorResponse<CompleteOrderEntity>():
          emit(state.copyWith(completeOrderState: BaseState<CompleteOrderEntity>(isLoading: false, errorMessage: response.errorMessage)));
          break;
      }
    } catch (e) {
      emit(state.copyWith(completeOrderState: BaseState<CompleteOrderEntity>(isLoading: false, errorMessage: e.toString())));
    }
  }
}
