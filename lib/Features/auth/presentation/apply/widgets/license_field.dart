import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class LicenseField extends StatefulWidget {
  final ValueChanged<File> onFileSelected;

  const LicenseField({super.key , required this.onFileSelected});

  @override
  State<LicenseField> createState() => _LicenseFieldState();
}

class _LicenseFieldState extends State<LicenseField> {
  final _controller = TextEditingController();
  final picker = ImagePicker();

  File? _image;

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      _image = File(picked.path);

      _controller.text = picked.name;

      widget.onFileSelected(_image!);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 35),
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            readOnly: true,
            onTap: _pickImage,
            decoration: InputDecoration(
              labelText: context.l10n.vehicleLicense,
              hintText: context.l10n.uploadLicensePhoto,
              prefixIcon: (_image != null)
                  ?  Icon(Icons.check_circle_outline_rounded , color: AppColors.green,)
                  :const SizedBox(height: 12),
              suffixIcon: Icon(Icons.file_upload_outlined , color: AppColors.gray,),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
