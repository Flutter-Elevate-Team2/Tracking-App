import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_shimmer_loading.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_view_body.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/order_card.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'home_view_test.mocks.dart';

@GenerateMocks([HomeViewModel])
void main() {
  late MockHomeViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockHomeViewModel();
    // Default stubs
    when(mockViewModel.state).thenReturn(const HomeState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<HomeViewModel>.value(
        value: mockViewModel,
        child: const Scaffold(body: HomeViewBody()),
      ),
    );
  }

  group('HomeViewBody Widget Tests', () {
    testWidgets('renders HomeHeader and No pending orders when list is empty', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        when(mockViewModel.state).thenReturn(
          const HomeState(ordersState: BaseState(isLoading: false, data: [])),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(HomeHeader), findsOneWidget);
        expect(find.text('No pending orders'), findsOneWidget);
      });
    });

    testWidgets('renders HomeShimmerLoading when loading', (
      WidgetTester tester,
    ) async {
      when(
        mockViewModel.state,
      ).thenReturn(const HomeState(ordersState: BaseState(isLoading: true)));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(HomeShimmerLoading), findsOneWidget);
    });

    testWidgets('renders OrderCards when data is present', (
      WidgetTester tester,
    ) async {
      final tOrders = [
        const OrderEntity(id: '1', orderNumber: '#1', totalPrice: 100),
      ];
      when(mockViewModel.state).thenReturn(
        HomeState(ordersState: BaseState(isLoading: false, data: tOrders)),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(OrderCard), findsNWidgets(1));
        expect(find.text('Flower order #1'), findsOneWidget);
      });
    });
  });
}
