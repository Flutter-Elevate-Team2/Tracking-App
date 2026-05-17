import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final BaseState<LoginEntity>? loginState;
  final bool isRememberMe;
  final String? activeOrderId;

  const LoginState({
    this.loginState,
    this.isRememberMe = false,
    this.activeOrderId,
  });

  LoginState copyWith({
    BaseState<LoginEntity>? loginState,
    bool? isRememberMe,
    String? activeOrderId,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
      isRememberMe: isRememberMe ?? this.isRememberMe,
      activeOrderId: activeOrderId ?? this.activeOrderId,
    );
  }

  @override
  List<Object?> get props => [loginState, isRememberMe, activeOrderId];
}
