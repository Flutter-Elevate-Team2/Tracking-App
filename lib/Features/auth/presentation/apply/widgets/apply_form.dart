import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/country_entities.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_events.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_states.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/country_field.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/email_field.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/id_image_field.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/license_field.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/name_fields.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/password_row.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/phone_field.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/presentation/views/vehicle_type_field.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';
import 'package:tracking_app/core/widget/custom_button.dart';
import 'package:tracking_app/core/widget/gender_radio_list_tile.dart';

class ApplyForm extends StatefulWidget {
  const ApplyForm({super.key});

  @override
  State<ApplyForm> createState() => _ApplyFormState();
}

class _ApplyFormState extends State<ApplyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
  TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  VehicleEntity? _selectedVehicle;
  CountryEntity? _selectedCountry;
  Gender? _selectedGender;
  File? _vehicleLicenseFile;
  File? _nidImageFile;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vehicleNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplyViewModel, ApplyStates>(
      builder: (context, state) {
        final isLoading = state.applyState?.isLoading ?? false;

        return Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: BlocListener<ApplyViewModel, ApplyStates>(
            listener: (context, state) {
              final applyState = state.applyState;
              if (applyState?.data != null) {
                context.pushNamed(Routes.successApplyName);
              } else if (state.applyState?.isLoading == true){
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: CircularProgressIndicator(),
                );
              }else if (applyState?.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(applyState!.errorMessage!),
                    backgroundColor: AppColors.red,
                  ),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Country dropdown
                CountryField(
                  initialCountry: _selectedCountry,
                  onChanged: (val) {
                    setState(() => _selectedCountry = val);
                  },
                ),

                const SizedBox(height: 16),

                // First & Second name
                NameFields(
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                ),
                // Vehicle Type
                VehicleTypeField(
                  selectedVehicle: _selectedVehicle,
                  onChanged: (type) {
                    setState(() {
                      _selectedVehicle = type;
                    });
                  },
                ),
                SizedBox(height: 35),

                // Vehicle Number
                TextFormField(
                  controller: _vehicleNumberController,
                  validator: (value) =>
                      FormValidators.validateVehicleNumber(context, value),
                  decoration: InputDecoration(
                    labelText: context.l10n.vehicleNumber,
                    hintText: context.l10n.vehicleNumber,
                  ),
                ),

                // Vehicle license file upload (placeholder button)
                LicenseField(
                  onFileSelected: (file) {
                    setState(() {
                      _vehicleLicenseFile = file;
                    });
                  },
                ),

                // Email
                EmailField(controller: _emailController),

                // Phone
                PhoneField(
                  controller: _phoneController,
                  countryCode: _selectedCountry?.phoneCode,
                ),

                // National ID
                TextFormField(
                  controller: _nidController,
                  validator: (value) =>
                      FormValidators.validateNationalId(context, value),
                  decoration: InputDecoration(
                    labelText: context.l10n.idNumberLabel,
                    hintText: context.l10n.idNumberHint,
                  ),
                ),

                // ID image upload
                IdImageField(
                  onFileSelected: (file) {
                    setState(() {
                      _nidImageFile = file;
                    });
                  },
                ),

                // Password & Confirm Password
                PasswordRow(
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  isPasswordVisible: _isPasswordVisible,
                  isConfirmPasswordVisible: _isConfirmPasswordVisible,
                  togglePasswordVisibility: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  toggleConfirmPasswordVisibility: () {
                    setState(
                          () => _isConfirmPasswordVisible =
                      !_isConfirmPasswordVisible,
                    );
                  },
                  formKey: _formKey,
                ),
                // Gender radio
                GenderRadioRow(
                  selectedGender: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      title: context.l10n.continueButton,
                      onPressed: isLoading
                          ? null
                          : () {
                        setState(
                              () => _autovalidateMode = AutovalidateMode.always,
                        );
                        if (_formKey.currentState!.validate()) {
                          context.read<ApplyViewModel>().doIntent(
                            OnApplyClickEvent(
                              applyRequest: ApplyRequest(
                                country: _selectedCountry!.name!,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                vehicleType: _selectedVehicle!.id ?? "",
                                vehicleNumber:
                                _vehicleNumberController.text,
                                email: _emailController.text,
                                phone:
                                "+${_selectedCountry?.phoneCode}${_phoneController
                                    .text}",
                                nid: _nidController.text,
                                password: _passwordController.text,
                                rePassword: _confirmPasswordController.text,
                                gender: _selectedGender!.name,
                                vehicleLicense: _vehicleLicenseFile!,
                                nidImg: _nidImageFile!,
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
