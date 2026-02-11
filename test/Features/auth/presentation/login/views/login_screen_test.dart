import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/login/views/login_screen.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class MockLoginViewModel extends MockCubit<LoginState>
    implements LoginViewModel {}

void main() {
  late MockLoginViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockLoginViewModel();
    GetIt.I.registerSingleton<LoginViewModel>(mockViewModel);
  });

  tearDown(() {
    GetIt.I.unregister<LoginViewModel>();
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Home Screen'))),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  testWidgets('LoginScreen renders correctly', (tester) async {
    whenListen(
      mockViewModel,
      Stream.value(LoginState()),
      initialState: LoginState(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
  });

  testWidgets('show error snack bar on login error', (tester) async {
    whenListen(
      mockViewModel,
      Stream.fromIterable([
        LoginState(loginState: BaseState(isLoading: true)),
        LoginState(
          loginState: BaseState(isLoading: false, errorMessage: 'Login Failed'),
        ),
      ]),
      initialState: LoginState(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump();

    expect(find.text('Login Failed'), findsOneWidget);
  });

  testWidgets('show CircularProgressIndicator when loading', (tester) async {
    whenListen(
      mockViewModel,
      Stream.fromIterable([LoginState(loginState: BaseState(isLoading: true))]),
      initialState: LoginState(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('navigates to home on successful login', (tester) async {
    whenListen(
      mockViewModel,
      Stream.fromIterable([
        LoginState(
          loginState: BaseState(
            data: LoginEntity(token: "token", message: "Welcome"),
          ),
        ),
      ]),
      initialState: LoginState(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
  });
}
