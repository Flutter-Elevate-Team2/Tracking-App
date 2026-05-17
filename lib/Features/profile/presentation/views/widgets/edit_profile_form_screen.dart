import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/gender_selection.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_avatar.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_text_form_field.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  String currentGender = "male";
  String photoUrl = "";
  DriverEntity? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getIt<SessionController>().user;
    if (currentUser != null) {
      currentGender = currentUser?.gender ?? "male";
      photoUrl = currentUser?.photo ?? " ";
    }

    firstNameController = TextEditingController(
      text: currentUser?.firstName ?? "",
    );
    lastNameController = TextEditingController(
      text: currentUser?.lastName ?? "",
    );
    phoneController = TextEditingController(text: currentUser?.phone ?? "");
    emailController = TextEditingController(text: currentUser?.email ?? "");

    firstNameController.addListener(_updateButtonState);
    lastNameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    phoneController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    bool isValid = firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty;

    bool hasChanges = false;

    if (currentUser != null) {
      hasChanges =
          firstNameController.text != (currentUser?.firstName ?? "") ||
          lastNameController.text != (currentUser?.lastName ?? "") ||
          emailController.text != (currentUser?.email ?? "") ||
          phoneController.text != (currentUser?.phone ?? "");
    }

    setState(() {
      _isButtonEnabled = isValid && hasChanges;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditProfileViewModel, EditProfileStates>(
          listenWhen: (previous, current) =>
              previous.editProfileState != current.editProfileState,
          listener: (context, state) {
            final editState = state.editProfileState;

            if (editState?.isLoading ?? false) return;

            if (editState?.data != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.profileUpdatedSuccess)),
              );

              currentUser = editState!.data!;
              _updateButtonState();
            } else if (editState?.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(editState!.errorMessage!)));
            }
          },
        ),
        BlocListener<EditProfileViewModel, EditProfileStates>(
          listenWhen: (previous, current) =>
              previous.uploadPhotoState != current.uploadPhotoState,
          listener: (context, state) {
            final uploadState = state.uploadPhotoState;

            if (uploadState?.isLoading ?? false) return;

            if (uploadState?.data != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text(context.l10n.photoUploadedSuccessfully),
                ),
              );
              // Update local state to reflect new photo
              setState(() {
                currentUser = getIt<SessionController>().user;
              });
            } else if (uploadState?.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(uploadState!.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 24),
            ProfileAvatar(photoUrl: currentUser?.photo),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ProfileTextField(
                    label: context.l10n.firstNamelabel,
                    controller: firstNameController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ProfileTextField(
                    label: context.l10n.lastNameLabel,
                    controller: lastNameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ProfileTextField(
              label: context.l10n.emailLabel,
              controller: emailController,
            ),
            const SizedBox(height: 24),
            ProfileTextField(
              label: context.l10n.phoneLabel,
              controller: phoneController,
            ),
            const SizedBox(height: 24),
            ProfileTextField(
              label: context.l10n.passwordLabel,
              initialValue: "********",
              isObscure: true,
              readOnly: true,
              trailing: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(Routes.resetPasswordName);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerRight,
                  ),
                  child: Text(
                    context.l10n.change,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            GenderSelectionSection(selectedGender: currentGender),
            const SizedBox(height: 40),
            BlocBuilder<EditProfileViewModel, EditProfileStates>(
              builder: (context, state) {
                final isLoading = state.editProfileState?.isLoading ?? false;
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                    ),
                    onPressed: _isButtonEnabled && !isLoading
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              context.read<EditProfileViewModel>().doIntent(
                                EditProfileEvent(
                                  EditProfileRequest(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(context.l10n.update),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
