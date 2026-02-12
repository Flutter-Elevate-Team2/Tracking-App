import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class IdImageField extends StatefulWidget {
  final ValueChanged<File> onFileSelected;
  const IdImageField({super.key, required this.onFileSelected});

  @override
  State<IdImageField> createState() => _IdImageFieldState();
}

class _IdImageFieldState extends State<IdImageField> {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            readOnly: true,
            onTap: _pickImage,
            decoration: InputDecoration(
              labelText: context.l10n.idImageLabel,
              hintText: context.l10n.uploadIdImage,
              prefixIcon: (_image != null)
                  ?  Icon(Icons.check_circle_outline_rounded , color: AppColors.green,)
                  :const SizedBox(height: 12),
              suffixIcon: const Icon(
                Icons.file_upload_outlined,
                color: AppColors.gray,
              ),
              border: const OutlineInputBorder(),
            ),
          ),

          if (_image != null) ...[
            const SizedBox(height: 12),
            Image.file(_image!, height: 120),
          ],
        ],
      ),
    );
  }
}
