import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/map_markers_overlay.dart';

void main() {
  late ValueNotifier<Offset?> driverOffset;
  late ValueNotifier<Offset?> storeOffset;
  late ValueNotifier<Offset?> userOffset;

  setUp(() {
    driverOffset = ValueNotifier<Offset?>(null);
    storeOffset = ValueNotifier<Offset?>(null);
    userOffset = ValueNotifier<Offset?>(null);
  });

  Widget createWidgetUnderTest({required bool showPickup}) {
    return MaterialApp(
      home: Scaffold(
        body: MapMarkersOverlay(
          driverOffset: driverOffset,
          storeOffset: storeOffset,
          userOffset: userOffset,
          showPickup: showPickup,
        ),
      ),
    );
  }

  group('MapMarkersOverlay Full Coverage Tests', () {
    testWidgets('should show nothing when all offsets are null', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(showPickup: true));

      expect(find.byType(Image), findsNothing);
    });

    testWidgets(
      'should show driver and store markers when showPickup is true',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(showPickup: true));

        driverOffset.value = const Offset(100, 100);
        storeOffset.value = const Offset(200, 200);

        await tester.pump();

        expect(find.byType(Positioned), findsNWidgets(2));
        expect(find.byType(Image), findsNWidgets(2));
      },
    );

    testWidgets(
      'should show driver and user markers when showPickup is false',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(showPickup: false));

        driverOffset.value = const Offset(100, 100);
        userOffset.value = const Offset(300, 300);

        await tester.pump();

        expect(find.byType(Positioned), findsNWidgets(2));
        expect(find.byType(Image), findsNWidgets(2));
      },
    );

    testWidgets('should update position when notifier value changes', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(showPickup: true));

      driverOffset.value = const Offset(100, 100);
      await tester.pump();

      Positioned positioned = tester.widget(find.byType(Positioned).first);
      expect(positioned.left, 100 - 45);

      driverOffset.value = const Offset(150, 150);
      await tester.pump();

      positioned = tester.widget(find.byType(Positioned).first);
      expect(positioned.left, 150 - 45);
    });
  });
}
