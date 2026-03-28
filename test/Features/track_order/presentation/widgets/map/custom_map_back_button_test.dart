import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/custom_map_back_button.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockNavigatorObserver mockObserver;
  provideDummy<Route<dynamic>>(MaterialPageRoute(builder: (_) => Container()));
  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      navigatorObservers: [mockObserver],
      home: Scaffold(
        body: const CustomMapBackButton(),
      ),
    );
  }

  group('CustomMapBackButton Tests', () {
    testWidgets('Should display correct icon and decoration', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final containerWidget = tester.widget<Container>(containerFinder);
      final decoration = containerWidget.decoration as BoxDecoration;

      expect(decoration.color, AppColors.mainColor);
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.boxShadow, isNotNull);
    });

    testWidgets('Should have correct padding and icon size', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, const EdgeInsets.all(10));

      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_back_ios_new));
      expect(icon.size, 18);
      expect(icon.color, AppColors.white);
    });
  });
}