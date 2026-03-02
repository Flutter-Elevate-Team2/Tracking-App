import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_view_model.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_events.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_states.dart';
import 'package:tracking_app/Features/vehicle/presentation/views/vehicles_drop_down_list.dart';
import 'package:tracking_app/core/di/di.dart';

class VehicleTypeField extends StatelessWidget {

  final void Function(VehicleEntity?)? onChanged;
  final VehicleEntity? selectedVehicle;

  const VehicleTypeField({super.key , this.onChanged  ,this.selectedVehicle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => getIt<VehicleViewModel>()..doIntent(GetAllVehiclesEvent()),
        child: BlocBuilder<VehicleViewModel, VehicleStates>(
            builder: (context, state) {
              final viewModel = context.read<VehicleViewModel>();
              if (state.vehiclesState!.errorMessage != null) {
                return Center(child: Text(state.vehiclesState!.errorMessage!));
              }

              final vehicles = state.vehiclesState!.data ?? [];

              return
                VehiclesDropDownList(
                    vehicles: vehicles,
                    selectedVehicleId: state.selectedVehicle?.id,
                    onVehicleSelected:  (id) {
                      viewModel.doIntent(SelectVehicleEvent(vehicleId: id));
                      final selected = vehicles.firstWhere((v) => v.id == id);
                      if (onChanged != null) {
                        onChanged!(selected);
                      }}

                );
            }
        )
    );
  }
}
