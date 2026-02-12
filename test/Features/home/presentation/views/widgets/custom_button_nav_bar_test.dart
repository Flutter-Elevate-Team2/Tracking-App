import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/custom_button_nav_bar.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  group('CustomButtonNavigationBar Widget Tests', () {
    testWidgets('should render CustomButtonNavigationBar correctly', (
      tester,
    ) async {
      // Arrange
      int selectedIndex = 0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: CustomButtonNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) => selectedIndex = index,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CustomButtonNavigationBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should display all three navigation items', (tester) async {
      // Arrange
      int selectedIndex = 0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: CustomButtonNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) => selectedIndex = index,
            ),
          ),
        ),
      );

      // Assert - Check for icons
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.fact_check_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('should highlight the current selected item', (tester) async {
      // Arrange
      int selectedIndex = 1; // Select second item (Orders)

      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: CustomButtonNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {},
            ),
          ),
        ),
      );

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Assert
      expect(navBar.currentIndex, equals(1));
    });

    testWidgets('should call onTap callback when item is tapped', (
      tester,
    ) async {
      // Arrange
      int selectedIndex = 0;
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: CustomButtonNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      // Act - Tap on the second item (Orders)
      await tester.tap(find.byIcon(Icons.fact_check_outlined));
      await tester.pump();

      // Assert
      expect(tappedIndex, equals(1));
    });

    testWidgets('should call onTap callback when profile item is tapped', (
      tester,
    ) async {
      // Arrange
      int selectedIndex = 0;
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: CustomButtonNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      // Act - Tap on the third item (Profile)
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pump();

      // Assert
      expect(tappedIndex, equals(2));
    });

    testWidgets('should update currentIndex when changed', (tester) async {
      // Arrange
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: CustomButtonNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      // Act - Tap on the second item
      await tester.tap(find.byIcon(Icons.fact_check_outlined));
      await tester.pumpAndSettle();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Assert
      expect(navBar.currentIndex, equals(1));
    });

    testWidgets('should have correct number of items', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: CustomButtonNavigationBar(
              currentIndex: 0,
              onTap: (index) {},
            ),
          ),
        ),
      );

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Assert
      expect(navBar.items.length, equals(3));
    });
  });
}
