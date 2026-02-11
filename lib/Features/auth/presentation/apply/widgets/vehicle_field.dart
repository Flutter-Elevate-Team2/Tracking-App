import 'package:flutter/material.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

enum VehicleType { car, truck, motorcycle, bicycle, bus }

class VehicleTypeField extends StatefulWidget {
  final VehicleType? initialValue;
  final ValueChanged<VehicleType?> onChanged;
  final TextEditingController? vehicleNumberController;

  const VehicleTypeField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.vehicleNumberController,
  });

  @override
  State<VehicleTypeField> createState() => _VehicleTypeFieldState();
}

class _VehicleTypeFieldState extends State<VehicleTypeField> {
  VehicleType? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue ?? VehicleType.car;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButtonFormField<VehicleType>(
            value: _selected,
            validator: (value) => value == null ? context.l10n.required : null,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.l10n.vehicleType,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items: VehicleType.values.map((type) {
              return DropdownMenuItem<VehicleType>(
                value: type,
                child: Text(type.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selected = value;
              });
              widget.onChanged(value);
            },
          ),
          SizedBox(height: 35),
          TextFormField(
            controller: widget.vehicleNumberController,
            validator: (value) =>
                FormValidators.validateVehicleNumber(context, value),
            decoration: InputDecoration(
              labelText: context.l10n.vehicleNumber,
              hintText: context.l10n.vehicleNumber,
            ),
          ),
        ],
    );
  }
}
