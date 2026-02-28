import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_body.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

@GenerateNiceMocks([MockSpec<OrderStatusViewModel>()])
import 'track_order_body_test.mocks.dart';

void main() {
  late MockOrderStatusViewModel mockViewModel;

   final fakeOrder = OrderTrackingEntity(
    orderNumber: "ORD-123",
    status: "delivering",
    updatedAt: DateTime.now(),
    totalPrice: 500.0,
    paymentType: "Card",
    shippingAddress: "Cairo, Egypt",
    store: StoreEntity(
        storeName: "My Store",
        storeAddress: "Store Address",
        storeImage: "",
        storePhone: "123456"
        , storeLat: 123,
        storeLong: 456
    ),
    user: UserEntity(
        userName: "John Doe",
        userImage: "",
        userPhone: "78910",
        deviceToken: "mock_token"
    ),
    items: [],
     trackingLocation: TrackingLocationEntity(
       lat: 123,
       long: 123,
     ),
     userLocationEntity: UserLocationEntity(
       lat: 123,
       long: 123,
     ), id: '',
  );

  setUp(() {
    mockViewModel = MockOrderStatusViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<OrderStatusViewModel>.value(
        value: mockViewModel,
        child: const TrackOrderBody(orderId: "ORD-123"),
      ),
    );
  }

  group('TrackOrderBody Widget Tests', () {
    testWidgets('should render SizedBox.shrink when order data is null', (tester) async {
      when(mockViewModel.state).thenReturn(const TrackOrderStatusState(
        orderState: BaseState(data: null),
      ));
      when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(Scaffold), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should render full page content when data is loaded successfully', (tester) async {
      when(mockViewModel.state).thenReturn(TrackOrderStatusState(
        orderState: BaseState(data: fakeOrder),
      ));
      when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.textContaining("ORD-123"), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text("John Doe"), findsOneWidget);
    });

    testWidgets('should show SnackBar when back button is pressed and order is not delivered', (tester) async {
       when(mockViewModel.state).thenReturn(TrackOrderStatusState(
        orderState: BaseState(data: fakeOrder),
      ));
      when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

       await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should reflect loading state in stepper when status is updating', (tester) async {
      when(mockViewModel.state).thenReturn(TrackOrderStatusState(
        orderState: BaseState(data: fakeOrder),
        updateStatusState: const BaseState(isLoading: true),
      ));
      when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}