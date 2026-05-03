import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/my_orders_body.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/my_orders_loading.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

import 'my_orders_body_test.mocks.dart';


@GenerateMocks([MyOrdersViewModel])
void main() {
  late MockMyOrdersViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockMyOrdersViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<MyOrdersViewModel>.value(
        value: mockViewModel,
        child: const Scaffold(body: MyOrdersBody()),
      ),
    );
  }

  group('MyOrdersBody Widget Tests', () {
    testWidgets('triggers GetDriverOrdersEvent on initState', (tester) async {
      when(mockViewModel.state).thenReturn(const MyOrdersState(isLoading: true));
      when(mockViewModel.stream).thenAnswer((_) => Stream.value(const MyOrdersState(isLoading: true)));

      await tester.pumpWidget(createWidgetUnderTest());

      verify(mockViewModel.doIntent(any)).called(1);
    });

    testWidgets('should show MyOrdersLoading when state is loading', (tester) async {
      // Arrange
      final loadingState = const MyOrdersState(isLoading: true);

      when(mockViewModel.state).thenReturn(loadingState);
       when(mockViewModel.stream).thenAnswer((_) => Stream.value(loadingState));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

       await tester.pump();

      // Assert
       expect(find.byType(MyOrdersLoading), findsOneWidget);

       expect(find.byType(AppShimmer), findsWidgets);


    });

    testWidgets('shows error message when errorMessage is not null', (tester) async {
      const errorMsg = 'Failed to fetch data';
      when(mockViewModel.state).thenReturn(const MyOrdersState(isLoading: false, errorMessage: errorMsg));
      when(mockViewModel.stream).thenAnswer((_) => Stream.value(const MyOrdersState(isLoading: false, errorMessage: errorMsg)));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMsg), findsOneWidget);
    });

});}