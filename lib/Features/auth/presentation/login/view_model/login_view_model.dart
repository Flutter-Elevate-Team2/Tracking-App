import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/Features/auth/domain/use_cases/login_use_cases/login_use_case.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final SessionController _sessionController;

  LoginViewModel(this._loginUseCase, this._sessionController)
    : super(LoginState());

  void doIntent(LoginEvent event) {
    switch (event) {
      case LoginInitialEvent():
        _onInit();
        break;
      case ToggleRememberMeEvent():
        _toggleRememberMe();
        break;
      case UserTypingEvent():
        _resetErrorState();
        break;
      case LoginButtonClickedEvent():
        _handleLogin(event);
        break;
    }
  }

  void _onInit() {
    emit(LoginState());
  }

  void _toggleRememberMe() {
    emit(
      state.copyWith(
        isRememberMe: !state.isRememberMe,
        loginState: BaseState(),
      ),
    );
  }

  void _resetErrorState() {
    if (state.loginState?.errorMessage != null ||
        state.loginState?.isLoading == true) {
      emit(state.copyWith(loginState: BaseState()));
    }
  }

  Future<void> _handleLogin(LoginButtonClickedEvent event) async {
    emit(state.copyWith(loginState: BaseState(isLoading: true)));

    final response = await _loginUseCase.call(
      LoginRequest(email: event.email, password: event.password),
      isRememberMe: state.isRememberMe,
    );

    switch (response) {
      case SuccessResponse<LoginEntity>():
        _sessionController.notifyLogin();

        emit(
          state.copyWith(
            loginState: BaseState(isLoading: false, data: response.data),
          ),
        );
        break;

      case ErrorResponse<LoginEntity>():
        emit(
          state.copyWith(
            loginState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
