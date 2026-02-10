import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_driver_profile_use_case.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/di/di.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileStates> {
  final GetDriverProfileUseCase _getDriverProfileUseCase;

  ProfileViewModel(this._getDriverProfileUseCase)
    : super(const ProfileStates());

  void doIntent(ProfileEvents event) {
    switch (event) {
      case GetDriverProfileEvent():
        _getDriverProfile();
        break;
    }
  }

  Future<void> _getDriverProfile() async {
    emit(state.copyWith(profileState: BaseState(isLoading: true)));

    final result = await _getDriverProfileUseCase.call();

    switch (result) {
      case SuccessResponse<DriverEntity>():
        getIt<SessionController>().saveUser(result.data);

        emit(
          state.copyWith(
            profileState: BaseState(isLoading: false, data: result.data),
          ),
        );
        break;

      case ErrorResponse<DriverEntity>():
        emit(
          state.copyWith(
            profileState: BaseState(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
