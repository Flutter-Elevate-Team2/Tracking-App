import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_settings_tile.dart';

void main() {
  group('ProfileSettingsTile', () {
    testWidgets('renders title and icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileSettingsTile(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileSettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Logout'));
      expect(tapped, isTrue);
    });

    testWidgets('renders trailing widget when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileSettingsTile(
              icon: Icons.language,
              title: 'Language',
              onTap: () {},
              trailing: const Text('English'),
            ),
          ),
        ),
      );

      expect(find.text('English'), findsOneWidget);
    });
  });
}
