import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/address_section.dart';

void main() {
  Widget createWidgetUnderTest({
    required String label,
    required String name,
    required String address,
    required String imagePath,
    VoidCallback? onPhoneTap,
    VoidCallback? onChatTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AddressSection(
          label: label,
          name: name,
          address: address,
          imagePath: imagePath,
          onPhoneTap: onPhoneTap,
          onChatTap: onChatTap,
        ),
      ),
    );
  }

  group('AddressSection Widget Tests', () {
    const testLabel = "Store Info";
    const testName = "Pizza Hut";
    const testAddress = "Main Street, Cairo";
    const testImageUrl = "https://example.com/image.png";

    testWidgets('should display correct texts (label, name, address)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        label: testLabel,
        name: testName,
        address: testAddress,
        imagePath: testImageUrl,
      ));

       expect(find.text(testLabel), findsOneWidget);
      expect(find.text(testName), findsOneWidget);
      expect(find.text(testAddress), findsOneWidget);

       expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('should render CachedNetworkImage with the provided imagePath', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        label: testLabel,
        name: testName,
        address: testAddress,
        imagePath: testImageUrl,
      ));

      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsOneWidget);

      final cachedImage = tester.widget<CachedNetworkImage>(imageFinder);
      expect(cachedImage.imageUrl, testImageUrl);
    });

    testWidgets('should trigger onPhoneTap when phone icon is pressed', (tester) async {
      bool isPhoneTapped = false;

      await tester.pumpWidget(createWidgetUnderTest(
        label: testLabel,
        name: testName,
        address: testAddress,
        imagePath: testImageUrl,
        onPhoneTap: () => isPhoneTapped = true,
      ));

       final phoneIcon = find.byIcon(Icons.phone_outlined);
      await tester.tap(phoneIcon);
      await tester.pump();

      expect(isPhoneTapped, true);
    });

    testWidgets('should trigger onChatTap when WhatsApp icon is pressed', (tester) async {
      bool isChatTapped = false;

      await tester.pumpWidget(createWidgetUnderTest(
        label: testLabel,
        name: testName,
        address: testAddress,
        imagePath: testImageUrl,
        onChatTap: () => isChatTapped = true,
      ));

       final socialIcons = find.byType(GestureDetector);

       await tester.tap(socialIcons.last);
      await tester.pump();

      expect(isChatTapped, true);
    });
    testWidgets('should apply ellipsis to address text when it is very long', (tester) async {
      const longAddress = "This is a very very very long address that should definitely be truncated because it exceeds the available space";

      await tester.pumpWidget(createWidgetUnderTest(
        label: testLabel,
        name: testName,
        address: longAddress,
        imagePath: testImageUrl,
      ));

      final textWidget = tester.widget<Text>(find.text(longAddress));

      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 1);
    });
  });
}