import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/bottom_order_button.dart';
 import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_action_button.dart';

import 'bottom_order_button_test.mocks.dart';

@GenerateMocks([OrderStatusViewModel])
void main() {
  late MockOrderStatusViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockOrderStatusViewModel();
  });

  Widget createWidgetUnderTest({
    required OrderStatus currentStatus,
  }) {
    return MaterialApp(
       localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
       home: Scaffold(
        body: BlocProvider<OrderStatusViewModel>.value(
          value: mockViewModel,
          child: BuildBottomButton(
            orderId: "123",
            userToken: "token_abc",
            currentStatus: currentStatus,
          ),
        ),
      ),
    );
  }

  group('BuildBottomButton Widget Tests', () {

    testWidgets('should render OrderActionButton and handle translation correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(currentStatus: OrderStatus.arrivedUser));

       expect(find.byType(OrderActionButton), findsOneWidget);
    });

    testWidgets('should call doIntent when button is pressed', (tester) async {
      when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
      when(mockViewModel.state).thenReturn(TrackOrderStatusState());

      await tester.pumpWidget(createWidgetUnderTest(currentStatus: OrderStatus.arrivedUser));

      await tester.tap(find.byType(OrderActionButton));
      await tester.pump();

      verify(mockViewModel.doIntent(any, any)).called(1);
    });  });
}