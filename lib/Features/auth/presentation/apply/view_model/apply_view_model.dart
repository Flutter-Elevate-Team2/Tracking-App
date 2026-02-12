import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';
import 'package:tracking_app/Features/auth/domain/use_cases/apply_use_cases/apply_use_case.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_events.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_states.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

@injectable
class ApplyViewModel extends Cubit<ApplyStates> {
  final ApplyUseCase _applyUseCase;

  ApplyViewModel(this._applyUseCase) : super(ApplyStates());

  void doIntent(ApplyEvent event) {
    switch (event) {
      case OnApplyClickEvent _:
        _handleApply(event);
        break;
    }
  }

  void _handleApply(OnApplyClickEvent event) async {
    emit(state.copyWith(applyState: BaseState<ApplyEntity>(isLoading: true)));

    final response = await _applyUseCase.call(event.applyRequest);

    switch (response) {
      case SuccessResponse<ApplyEntity>():
        emit(
          state.copyWith(
            applyState: BaseState<ApplyEntity>(
              isLoading: false,
              data: response.data,
              errorMessage: null,
            ),
          ),
        );
        break;

      case ErrorResponse<ApplyEntity>():
        emit(
          state.copyWith(
            applyState: BaseState<ApplyEntity>(
              isLoading: false,
              data: null,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
