import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/views/my_orders_screen.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/my_orders_body.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/my_orders_loading.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

@GenerateMocks([MyOrdersViewModel])
import 'my_orders_screen_test.mocks.dart';

void main() {
  late MockMyOrdersViewModel mockViewModel;

  setUp(() async {
    mockViewModel = MockMyOrdersViewModel();

    when(mockViewModel.state).thenReturn(const MyOrdersState());
    when(mockViewModel.stream).thenAnswer((_) => Stream.value(const MyOrdersState()));
    when(mockViewModel.close()).thenAnswer((_) async => {});

    await getIt.reset();
    getIt.registerFactory<MyOrdersViewModel>(() => mockViewModel);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyOrdersScreen(),
    );
  }

  group('MyOrdersScreen Widget Tests', () {

    testWidgets('should render AppBar with correct title and back button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Verify AppBar existence
      expect(find.byType(AppBar), findsOneWidget);

      // Match the exact icon used in your code (Icons.arrow_back)
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Verify MyOrdersBody is rendered (inside BlocProvider)
      expect(find.byType(MyOrdersBody), findsOneWidget);
    });
    testWidgets('should call close on ViewModel when screen is disposed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpWidget(Container());

      verify(mockViewModel.close()).called(1);
    });

    testWidgets('should show MyOrdersLoading when state is loading', (tester) async {
      // 1. Arrange
      final loadingState = const MyOrdersState(isLoading: true);

      when(mockViewModel.state).thenReturn(loadingState);
      when(mockViewModel.stream).thenAnswer((_) => Stream.value(loadingState));

      // 2. Act
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      // 3. Assert
      expect(find.byType(MyOrdersLoading), findsOneWidget);

      expect(find.byType(AppShimmer), findsWidgets);
    });
    testWidgets('should display error message when state has errorMessage', (tester) async {
      // Arrange
      final errorState = const MyOrdersState(
        isLoading: false,
        errorMessage: 'Error fetching orders',
      );
      when(mockViewModel.state).thenReturn(errorState);
      when(mockViewModel.stream).thenAnswer((_) => Stream.value(errorState));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Error fetching orders'), findsOneWidget);
    });
  });
}