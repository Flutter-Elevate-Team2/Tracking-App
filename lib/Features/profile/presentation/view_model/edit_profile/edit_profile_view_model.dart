import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/di/di.dart';

@injectable
class EditProfileViewModel extends Cubit<EditProfileStates> {
  EditProfileViewModel({
    required this.editProfileUseCase,
    required this.uploadPhotoUseCase,
  }) : super(const EditProfileStates());
  final EditProfileUseCase editProfileUseCase;
  final UploadPhotoUseCase uploadPhotoUseCase;
  void doIntent(EditProfileEvents event) {
    switch (event) {
      case EditProfileEvent():
        _editProfile(event.request);
        break;
      case UploadPhotoEvent():
        _uploadPhoto(event.file);
        break;
    }
  }

  void _editProfile(EditProfileRequest request) async {
    emit(state.copyWith(editProfileState: BaseState(isLoading: true)));
    final result = await editProfileUseCase(request);
    switch (result) {
      case SuccessResponse<DriverEntity>():
       
        getIt<SessionController>().saveUser(result.data);

        emit(
          state.copyWith(
            editProfileState: BaseState(isLoading: false, data: result.data),
          ),
        );
        break;
      case ErrorResponse<DriverEntity>():
        emit(
          state.copyWith(
            editProfileState: BaseState(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _uploadPhoto(File file) async {
    if (isClosed) return;
    emit(state.copyWith(uploadPhotoState: BaseState(isLoading: true)));
    final response = await uploadPhotoUseCase.call(file);
    if (isClosed) return;
    switch (response) {
      case SuccessResponse<String>():
        // Update SessionController with new photo URL
        final currentUser = getIt<SessionController>().user;
        if (currentUser != null) {
          final updatedUser = DriverEntity(
            id: currentUser.id,
            firstName: currentUser.firstName,
            lastName: currentUser.lastName,
            email: currentUser.email,
            phone: currentUser.phone,
            photo: response.data, // New photo URL from backend
            role: currentUser.role,
            gender: currentUser.gender, country: '', vehicleType: '', vehicleNumber: '', vehicleLicense: '', nid: '', nidImg: '',
          );
          getIt<SessionController>().saveUser(updatedUser);
        }

        emit(
          state.copyWith(
            uploadPhotoState: BaseState(isLoading: false, data: response.data),
          ),
        );
      case ErrorResponse<String>():
        emit(
          state.copyWith(
            uploadPhotoState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
