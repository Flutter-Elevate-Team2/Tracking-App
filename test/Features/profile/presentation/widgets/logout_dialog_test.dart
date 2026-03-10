import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/logout_dialog.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'logout_dialog_test.mocks.dart';

@GenerateMocks([ProfileViewModel])
void main() {
  late MockProfileViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockProfileViewModel();
    when(mockViewModel.state).thenReturn(const ProfileStates());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockViewModel.isClosed).thenReturn(false);
    when(mockViewModel.close()).thenAnswer((_) async {});
  });

  testWidgets('LogoutDialog renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: LogoutDialog()),
      ),
    );

    expect(find.text('Logout'), findsWidgets); // Found in Title and Button
    expect(find.text('Are you sure you want to logout?'), findsOneWidget);
    expect(find.text('cancel'), findsOneWidget);
  });

  testWidgets(
    'LogoutDialog triggers LogoutEvent when Logout button is pressed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const Scaffold(body: LogoutDialog()),
          ),
        ),
      );

      // Click the logout button in the dialog
      // There are two 'Logout' texts: title and action button.
      // We target the one specifically inside ElevatedButton or find by type.
      final logoutButton = find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.text('Logout'),
      );
      await tester.tap(logoutButton);
      await tester.pump();

      verify(mockViewModel.doIntent(argThat(isA<LogoutEvent>()))).called(1);
    },
  );
}
