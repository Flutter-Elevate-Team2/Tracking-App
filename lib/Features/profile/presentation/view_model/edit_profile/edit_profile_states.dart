import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
class EditProfileStates {
 final BaseState<DriverEntity>? editProfileState;
  final BaseState<String>? uploadPhotoState;

const  EditProfileStates({this.editProfileState, this.uploadPhotoState});

  EditProfileStates copyWith({
    BaseState<DriverEntity>? editProfileState,
    BaseState<String>? uploadPhotoState,
  }) {
    return EditProfileStates(
     editProfileState: editProfileState ?? this.editProfileState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
    );
  }
}