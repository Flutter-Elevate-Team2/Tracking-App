import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/views/track_order_screen.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_shimmer.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

@GenerateNiceMocks([MockSpec<OrderStatusViewModel>()])
import 'track_order_screen_test.mocks.dart';

void main() {
  late MockOrderStatusViewModel mockViewModel;
  const String tOrderId = '123';

  setUp(() {
    mockViewModel = MockOrderStatusViewModel();

    when(mockViewModel.state).thenReturn(const TrackOrderStatusState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockViewModel.close()).thenAnswer((_) async => {});

    GetIt.I.allowReassignment = true;
    GetIt.I.registerFactory<OrderStatusViewModel>(() => mockViewModel);
  });

  Widget createWidgetUnderTest(TrackOrderStatusState state) {
    when(mockViewModel.state).thenReturn(state);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: TrackOrderScreen(orderId: tOrderId),
    );
  }

  group('TrackOrderScreen Widget Tests', () {
    testWidgets('1. Displays Shimmer when loading', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const TrackOrderStatusState(orderState: BaseState(isLoading: true)),
        ),
      );

      await tester.pump();
      expect(find.byType(TrackOrderShimmer), findsOneWidget);
    });

    testWidgets('2. Displays Error Message', (tester) async {
      const errorMsg = 'Network Error';
      await tester.pumpWidget(
        createWidgetUnderTest(
          const TrackOrderStatusState(
            orderState: BaseState(errorMessage: errorMsg),
          ),
        ),
      );

      await tester.pump();
      expect(find.text(errorMsg), findsOneWidget);
    });

    testWidgets('4. Displays CircularProgressIndicator as default', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(const TrackOrderStatusState()),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
