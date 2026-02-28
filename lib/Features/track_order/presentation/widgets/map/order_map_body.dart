import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/map_markers_overlay.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class OrderMapBody extends StatefulWidget {
  const OrderMapBody({super.key});

  @override
  State<OrderMapBody> createState() => _OrderMapBodyState();
}

class _OrderMapBodyState extends State<OrderMapBody> {
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PolylineAnnotationManager? _polylineAnnotationManager;

  final ValueNotifier<Offset?> driverOffset = ValueNotifier(null);
  final ValueNotifier<Offset?> storeOffset = ValueNotifier(null);
  final ValueNotifier<Offset?> userOffset = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderStatusViewModel, TrackOrderStatusState>(
      listenWhen: (prev, curr) => prev.routePoints != curr.routePoints,
      listener: (context, state) {
        if (state.routePoints?.isNotEmpty ?? false) {
          _drawRoute(state.routePoints!);
          _fitCamera(state.routePoints!);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            mapbox.MapWidget(
              styleUri: mapbox.MapboxStyles.LIGHT,
              onMapCreated: (map) => _mapboxMap = map,
              onCameraChangeListener: (_) => _updateMarkers(state),
              onStyleLoadedListener: (_) async {
                _polylineAnnotationManager = await _mapboxMap!.annotations
                    .createPolylineAnnotationManager(below: "road-label");

                if (state.routePoints?.isNotEmpty ?? false) {
                  _drawRoute(state.routePoints!);
                }
              },
            ),
            MapMarkersOverlay(
              driverOffset: driverOffset,
              storeOffset: storeOffset,
              userOffset: userOffset,
              showPickup: state.showPickup,
            ),
          ],
        );
      },
    );
  }

  void _drawRoute(List<mapbox.Position> points) async {
    _polylineAnnotationManager ??= await _mapboxMap?.annotations
        .createPolylineAnnotationManager();

    if (_polylineAnnotationManager != null) {
      await _polylineAnnotationManager!.deleteAll();
      await _polylineAnnotationManager!.create(
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(coordinates: points),
          lineColor: AppColors.mainColor.toARGB32(),
          lineWidth: 5.0,
          lineOpacity: 0.8,
          lineJoin: mapbox.LineJoin.ROUND,
        ),
      );
    }
  }

  Future<void> _fitCamera(List<mapbox.Position> routePoints) async {
    if (_mapboxMap == null || routePoints.isEmpty) return;

    final points = routePoints
        .map((p) => mapbox.Point(coordinates: p))
        .toList();

    final padding = mapbox.MbxEdgeInsets(
      top: 100.0,
      left: 50.0,
      bottom: 350.0,
      right: 50.0,
    );

    final camera = await _mapboxMap!.cameraForCoordinatesPadding(
      points,
      mapbox.CameraOptions(),
      padding,
      null,
      null,
    );

    _mapboxMap!.flyTo(camera, mapbox.MapAnimationOptions(duration: 1500));
  }

  void _updateMarkers(TrackOrderStatusState state) async {
    final order = state.orderState?.data;
    if (_mapboxMap == null ||
        state.currentDriverPosition == null ||
        order == null) {
      return;
    }

    Future<Offset> getPos(double lat, double lng) async {
      final screenPos = await _mapboxMap!.pixelForCoordinate(
        mapbox.Point(coordinates: mapbox.Position(lng, lat)),
      );
      return Offset(screenPos.x, screenPos.y);
    }

    driverOffset.value = await getPos(
      state.currentDriverPosition!.latitude,
      state.currentDriverPosition!.longitude,
    );
    storeOffset.value = await getPos(
      order.store.storeLat.toDouble(),
      order.store.storeLong.toDouble(),
    );
    userOffset.value = await getPos(
      order.userLocationEntity.lat.toDouble(),
      order.userLocationEntity.long.toDouble(),
    );
  }
}
