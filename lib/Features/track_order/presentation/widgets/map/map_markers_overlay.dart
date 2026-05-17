import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/assets_manager.dart';

class MapMarkersOverlay extends StatelessWidget {
  final ValueNotifier<Offset?> driverOffset;
  final ValueNotifier<Offset?> storeOffset;
  final ValueNotifier<Offset?> userOffset;
  final bool showPickup;

  const MapMarkersOverlay({
    super.key,
    required this.driverOffset,
    required this.storeOffset,
    required this.userOffset,
    required this.showPickup,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildSingleMarker(
          driverOffset,
          AssetsManager.driverLocation,
          90,
          50,
          45,
          35,
        ),
        if (showPickup)
          _buildSingleMarker(
            storeOffset,
            AssetsManager.storeLocation,
            60,
            40,
            30,
            28,
          ),
        if (!showPickup)
          _buildSingleMarker(
            userOffset,
            AssetsManager.userLocation,
            60,
            30,
            40,
            25,
          ),
      ],
    );
  }

  Widget _buildSingleMarker(
    ValueNotifier<Offset?> notifier,
    String asset,
    double w,
    double h,
    double offW,
    double offH,
  ) {
    return ValueListenableBuilder<Offset?>(
      valueListenable: notifier,
      builder: (context, offset, _) {
        if (offset == null) return const SizedBox.shrink();
        return Positioned(
          left: offset.dx - offW,
          top: offset.dy - offH,
          child: Image.asset(asset, width: w, height: h),
        );
      },
    );
  }
}
