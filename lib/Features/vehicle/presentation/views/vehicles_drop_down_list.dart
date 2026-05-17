import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/extension/string_extension.dart';

class VehiclesDropDownList extends StatelessWidget {
  final List<VehicleEntity> vehicles;
  final String? selectedVehicleId;
  final ValueChanged<String> onVehicleSelected;

  const VehiclesDropDownList({
    super.key,
    required this.vehicles,
    required this.selectedVehicleId,
    required this.onVehicleSelected,
  });
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: const Key("vehicleTypeDropdown"),
      isExpanded: true,
      hint: Text(context.l10n.vehicleType),
      initialValue: selectedVehicleId,
      decoration: InputDecoration(
        labelText: context.l10n.vehicleType,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: vehicles.map((v) {
        return DropdownMenuItem<String>(
          key: Key("vehicleItem_${v.id}"),
          value: v.id,
          child: Row(
            children: [
              v.image != null && v.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: v.image!.toImageUrl,
                      key: Key("vehicleImage_${v.id}"),
                      width: 50,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const SizedBox(
                        width: 50,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Icon(
                      Icons.directions_car,
                      key: Key("vehicleIcon_${v.id}"),
                      size: 40,
                      color: AppColors.gray,
                    ),
              const SizedBox(width: 6),
              Text(v.type ?? ''),
            ],
          ),
        );
      }).toList(),
      onChanged: (id) {
        if (id != null) {
          onVehicleSelected(id);
        }
      },
    );
  }
}
