import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/custom_button.dart';

class EditVehicleScreen extends StatefulWidget {
  const EditVehicleScreen({super.key});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _vehicleNumberController;
  String? _selectedVehicleTypeId;
  File? _vehicleLicenseFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = getIt<SessionController>().user;
    _vehicleNumberController = TextEditingController(text: user?.vehicleNumber);
    _selectedVehicleTypeId = user?.vehicleType;
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _vehicleLicenseFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) =>
          getIt<ProfileViewModel>()..doIntent(GetVehiclesEvent()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(l10n?.editProfile ?? 'Edit vehicle'),
          centerTitle: false,
        ),
        body: BlocConsumer<ProfileViewModel, ProfileStates>(
          listener: (context, state) {
            if (state.editVehicleState?.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.editVehicleState!.errorMessage!)),
              );
            } else if (state.editVehicleState?.data != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n?.profileUpdatedSuccess ??
                        'Profile updated successfully',
                  ),
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final vehicles = state.vehiclesState?.data ?? [];
            final isLoadingVehicles = state.vehiclesState?.isLoading == true;

            // Ensure the selected ID still exists in the fetched list (defensive)
            if (_selectedVehicleTypeId != null &&
                vehicles.isNotEmpty &&
                !vehicles.any((v) => v.id == _selectedVehicleTypeId)) {
              // If it's not a valid ID from the list, don't crash, but maybe don't clear it yet
              // unless we are sure it's invalid.
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Vehicle Type Dropdown
                    if (isLoadingVehicles)
                      const LinearProgressIndicator()
                    else
                      DropdownButtonFormField<String>(
                        initialValue:
                            vehicles.any((v) => v.id == _selectedVehicleTypeId)
                            ? _selectedVehicleTypeId
                            : null,
                        hint: Text(l10n?.selectVehicleType ?? 'Select type'),
                        decoration: InputDecoration(
                          labelText: l10n?.vehicleType ?? 'Vehicle type',
                        ),
                        items: vehicles.map((vehicle) {
                          return DropdownMenuItem(
                            value: vehicle.id,
                            child: Text(vehicle.type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicleTypeId = value;
                          });
                        },
                        validator: (value) => value == null
                            ? (l10n?.vehicleTypeRequired ?? 'Required')
                            : null,
                      ),
                    const SizedBox(height: 24),
                    // Vehicle Number
                    TextFormField(
                      controller: _vehicleNumberController,
                      decoration: InputDecoration(
                        labelText: l10n?.vehicleNumber ?? 'Vehicle number',
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? (l10n?.vehicleNumberRequired ?? 'Required')
                          : null,
                    ),
                    const SizedBox(height: 24),
                    // Vehicle License (File Pick)
                    GestureDetector(
                      onTap: _pickImage,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText:
                                l10n?.vehicleLicense ?? 'Vehicle license',
                            hintText: _vehicleLicenseFile != null
                                ? _vehicleLicenseFile!.path.split('/').last
                                : 'Upload_License_Image',
                            suffixIcon: const Icon(Icons.file_upload_outlined),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      title: l10n?.update ?? 'Update',
                      onPressed:
                          state.editVehicleState?.isLoading == true ||
                              isLoadingVehicles
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ProfileViewModel>().doIntent(
                                  EditVehicleEvent(
                                    vehicleType: _selectedVehicleTypeId,
                                    vehicleNumber:
                                        _vehicleNumberController.text,
                                    vehicleLicense: _vehicleLicenseFile,
                                  ),
                                );
                              }
                            },
                      backgroundColor: AppColors.mainColor,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
