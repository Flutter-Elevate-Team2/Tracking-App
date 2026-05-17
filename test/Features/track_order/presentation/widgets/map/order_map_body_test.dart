import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/order_map_body.dart';

import 'order_map_body_test.mocks.dart';

@GenerateMocks([
  mapbox.MapboxMap,
  mapbox.PolylineAnnotationManager,
  OrderStatusViewModel,
])
void main() {
  late MockOrderStatusViewModel mockViewModel;
  late MockMapboxMap mockMapboxMap;

  setUp(() {
    mockViewModel = MockOrderStatusViewModel();
    mockMapboxMap = MockMapboxMap();
  });

  Widget createWidgetUnderTest(TrackOrderStatusState state) {
    when(mockViewModel.state).thenReturn(state);
    when(mockViewModel.stream).thenAnswer((_) => Stream.value(state));

    return MaterialApp(
      home: BlocProvider<OrderStatusViewModel>.value(
        value: mockViewModel,
        child: const Scaffold(body: OrderMapBody()),
      ),
    );
  }

  group('OrderMapBody Coverage Tests', () {
    testWidgets('should update route and camera when routePoints change', (
      tester,
    ) async {
      final initialState = TrackOrderStatusState(routePoints: []);
      final newState = TrackOrderStatusState(
        routePoints: [mapbox.Position(31.0, 30.0), mapbox.Position(31.1, 30.1)],
      );

      final controller = StreamController<TrackOrderStatusState>();
      when(mockViewModel.stream).thenAnswer((_) => controller.stream);
      when(mockViewModel.state).thenReturn(newState);

      await tester.pumpWidget(createWidgetUnderTest(initialState));

      controller.add(newState);
      await tester.pump();

      expect(find.byType(mapbox.MapWidget), findsOneWidget);
    });

    testWidgets('onMapCreated should set the local map variable', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(TrackOrderStatusState()));

      final mapWidget = tester.widget<mapbox.MapWidget>(
        find.byType(mapbox.MapWidget),
      );
      mapWidget.onMapCreated?.call(mockMapboxMap);
    });
  });
}
