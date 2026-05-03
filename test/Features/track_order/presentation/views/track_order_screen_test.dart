import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/views/track_order_screen.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_body.dart';
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

    // Stubbing أساسي لمنع الـ MissingStubError
    when(mockViewModel.state).thenReturn(const TrackOrderStatusState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockViewModel.close()).thenAnswer((_) async => {});

    // تسجيل الـ GetIt
    GetIt.I.allowReassignment = true;
    GetIt.I.registerFactory<OrderStatusViewModel>(() => mockViewModel);
  });

  // Helper لبناء الـ Widget مع توفير الـ Localizations
  Widget createWidgetUnderTest(TrackOrderStatusState state) {
    // نضمن أن الـ ViewModel يرجع الحالة المطلوبة قبل بناء الـ Widget
    when(mockViewModel.state).thenReturn(state);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate, // تأكد أن هذا الملف تم توليده بعمل flutter gen-l10n
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'), // نثبت اللغة على الإنجليزية للتأكد من الـ find.text
      home: TrackOrderScreen(orderId: tOrderId),
    );
  }

  group('TrackOrderScreen Widget Tests', () {

    testWidgets('1. Displays Shimmer when loading', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const TrackOrderStatusState(orderState: BaseState(isLoading: true)),
      ));

      // نستخدم pumpAndSettle لأن الـ Shimmer قد يحتوي على Animations
      await tester.pump();
      expect(find.byType(TrackOrderShimmer), findsOneWidget);
    });

    testWidgets('2. Displays Error Message', (tester) async {
      const errorMsg = 'Network Error';
      await tester.pumpWidget(createWidgetUnderTest(
        const TrackOrderStatusState(orderState: BaseState(errorMessage: errorMsg)),
      ));

      await tester.pump();
      expect(find.text(errorMsg), findsOneWidget);
    });

    // testWidgets('3. Displays Body when data arrived (Success)', (tester) async {
    //   final fakeOrderData = OrderTrackingEntity(
    //     orderNumber: 'ORD-2026-XYZ',
    //     status: 'out_for_delivery',
    //     updatedAt: DateTime.now(),
    //     totalPrice: 550.75,
    //     paymentType: 'Cash on Delivery',
    //     shippingAddress: '123 Test Street, Cairo, Egypt',
    //     items: [],
    //     store:   StoreEntity(
    //       storeName: 'Gourmet Burger Store',
    //       storeAddress: 'Maadi, Road 9',
    //       storeImage: 'https://example.com/store.png',
    //       storePhone: '01012345678',
    //     ),
    //     user:   UserEntity(
    //       userName: 'Ahmed Mohamed',
    //       userImage: 'https://example.com/user.png',
    //       userPhone: '01122334455',
    //       deviceToken: 'mock_token_123',
    //     ),
    //   );
    //
    //   await tester.pumpWidget(createWidgetUnderTest(
    //     TrackOrderStatusState(orderState: BaseState(data: fakeOrderData)),
    //   ));
    //
    //   // مهم جداً عمل pump للسماح للـ BlocBuilder بالتفاعل مع الحالة الجديدة
    //   await tester.pump();
    //
    //   expect(find.byType(TrackOrderBody), findsOneWidget);
    //   expect(find.text('ORD-2026-XYZ'), findsOneWidget);
    // });

    testWidgets('4. Displays CircularProgressIndicator as default', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const TrackOrderStatusState()));

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}