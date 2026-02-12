import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/di/di.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileViewModel, EditProfileStates>(
      builder: (context, state) {
        final uploadState = state.uploadPhotoState;
        final uploadedImageUrl = uploadState?.data;
        final isUploading = uploadState?.isLoading ?? false;

        // Get current user's photo from session as fallback
        final currentUserPhoto = getIt<SessionController>().user?.photo;

        // Use uploaded image URL if available, otherwise fall back to current user's photo
        final imageUrl = uploadedImageUrl ?? currentUserPhoto;

        return Stack(
          alignment: Alignment.center,
          children: [
            ProfileImageDisplay(imageUrl: imageUrl, isUploading: isUploading),
            Positioned(
              bottom: 0,
              right: 0,
              child: ProfileImagePicker(
                onImageSelected: (file) {
                  context.read<EditProfileViewModel>().doIntent(
                    UploadPhotoEvent(file),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileImageDisplay extends StatelessWidget {
  final String? imageUrl;
  final bool isUploading;

  const ProfileImageDisplay({
    super.key,
    required this.imageUrl,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGray,
        border: Border.all(color: AppColors.mainColor, width: 3),
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [_buildImage(), if (isUploading) _buildLoadingOverlay()],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lightGray,
      child: Icon(Icons.person, size: 60, color: AppColors.gray),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: AppColors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final Function(File) onImageSelected;

  const ProfileImagePicker({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
        ),
        child: Icon(Icons.camera_alt, color: AppColors.white, size: 18),
      ),
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => ImageSourceDialog(),
    );

    if (source != null) {
      _pickImage(context, source);
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        onImageSelected(file);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }
}

class ImageSourceDialog extends StatelessWidget {
  const ImageSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Image Source'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt, color: AppColors.mainColor),
            title: const Text('Camera'),
            onTap: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: AppColors.mainColor),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.of(context).pop(ImageSource.gallery);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
