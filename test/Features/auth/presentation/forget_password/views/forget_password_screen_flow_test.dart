import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/views/forget_password_screen_flow.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/shared/forget_password_screen_flow_body.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import '../widgets/reset_password_widgets/reset_password_form_test.mocks.dart';

void main() {
  late MockForgetPasswordViewModel mockViewModel;

  setUp(() async {
    await getIt.reset();

    mockViewModel = MockForgetPasswordViewModel();

    when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(
      mockViewModel.stream,
    ).thenAnswer((_) => Stream.value(ForgetPasswordState()));

    getIt.registerFactory<ForgetPasswordViewModel>(() => mockViewModel);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'ForgetPasswordScreenFlow should provide ViewModel and show Body',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ForgetPasswordScreenFlow(),
        ),
      );

      final blocProviderFinder = find.byType(
        BlocProvider<ForgetPasswordViewModel>,
      );
      expect(blocProviderFinder, findsOneWidget);

      final BuildContext context = tester.element(
        find.byType(ForgetPasswordScreenFlowBody),
      );
      final viewModel = BlocProvider.of<ForgetPasswordViewModel>(context);

      expect(viewModel, isNotNull);
      expect(find.byType(ForgetPasswordScreenFlowBody), findsOneWidget);
    },
  );
}
