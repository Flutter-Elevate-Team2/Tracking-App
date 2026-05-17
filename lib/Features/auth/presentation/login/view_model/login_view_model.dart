import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/Features/auth/domain/use_cases/login_use_cases/login_use_case.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_driver_profile_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';
import 'package:tracking_app/core/services/push_notification_service.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final SessionController _sessionController;
  final ActiveOrderFirestoreService _activeOrderFirestoreService;
  final GetDriverProfileUseCase _getDriverProfileUseCase;
  final FirebaseOrderService _firebaseOrderService; // <-- تمت الإضافة

  LoginViewModel(
    this._loginUseCase,
    this._sessionController,
    this._activeOrderFirestoreService,
    this._getDriverProfileUseCase,
    this._firebaseOrderService, // <-- تمت الإضافة
  ) : super(const LoginState());

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
    emit(const LoginState());
  }

  void _toggleRememberMe() {
    emit(
      state.copyWith(
        isRememberMe: !state.isRememberMe,
        loginState: const BaseState(),
      ),
    );
  }

  void _resetErrorState() {
    if (state.loginState?.errorMessage != null ||
        state.loginState?.isLoading == true) {
      emit(state.copyWith(loginState: const BaseState()));
    }
  }

  Future<void> _handleLogin(LoginButtonClickedEvent event) async {
    emit(state.copyWith(loginState: const BaseState(isLoading: true)));

    final response = await _loginUseCase.call(
      LoginRequest(email: event.email, password: event.password),
      isRememberMe: state.isRememberMe,
    );

    switch (response) {
      case SuccessResponse<LoginEntity>():
        _sessionController.notifyLogin();

        String? activeOrderId;
        String driverId = '';

        try {
          final profileResult = await _getDriverProfileUseCase.call();
          if (profileResult is SuccessResponse<DriverEntity>) {
            driverId = profileResult.data.id;
            _sessionController.saveUser(profileResult.data);
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(ApiConstants.driverIdKey, driverId);

            activeOrderId = await _activeOrderFirestoreService.getActiveOrder(driverId);
            
            if (activeOrderId != null && activeOrderId.isNotEmpty) {
               await prefs.setString(ApiConstants.currentOrderIdKey, activeOrderId);
               
               final newToken = await PushNotificationService.getDeviceTokenAsync();
               if (newToken != null) {
                 await _firebaseOrderService.updateDriverTokenInActiveOrder(activeOrderId, newToken);
               }
            }
          }
        } catch (e) {
          debugPrint("Sub-tasks failed during login: $e");
        }

        emit(
          state.copyWith(
            loginState: BaseState(isLoading: false, data: response.data),
            activeOrderId: activeOrderId,
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