import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_item_tile.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
   Widget createWidgetUnderTest({
    required String title,
    required String price,
    required int quantity,
    required String image,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: OrderItemTile(
          title: title,
          price: price,
          quantity: quantity,
          image: image,
        ),
      ),
    );
  }

  group('OrderItemTile Widget Tests', () {
    const testTitle = "Red Flowers Bouquet";
    const testPrice = "150.0";
    const testQuantity = 3;
    const testImageName = "flower.jpg";
    const expectedFullUrl = "https://flower.elevateegy.com/uploads/$testImageName";

    testWidgets('should display item details correctly (title, quantity, price)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        title: testTitle,
        price: testPrice,
        quantity: testQuantity,
        image: testImageName,
      ));

       expect(find.text(testTitle), findsOneWidget);
      expect(find.text("X$testQuantity"), findsOneWidget);

       expect(find.textContaining(testPrice), findsOneWidget);
    });

    testWidgets('should format the image URL correctly and pass it to CachedNetworkImage', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        title: testTitle,
        price: testPrice,
        quantity: testQuantity,
        image: testImageName,
      ));

      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsOneWidget);

       final cachedImage = tester.widget<CachedNetworkImage>(imageFinder);
      expect(cachedImage.imageUrl, expectedFullUrl);
    });

    testWidgets('should show errorWidget (CircleAvatar) when image fails to load', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest(
        title: testTitle,
        price: testPrice,
        quantity: testQuantity,
        image: testImageName,
      ));

      final imageWidget = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));

       expect(imageWidget.errorWidget, isNotNull);
    });

    testWidgets('should apply ellipsis to long titles', (tester) async {
      const longTitle = "This is an extremely long flower bouquet title that should definitely truncate";

      await tester.pumpWidget(createWidgetUnderTest(
        title: longTitle,
        price: testPrice,
        quantity: testQuantity,
        image: testImageName,
      ));

      final textWidget = tester.widget<Text>(find.text(longTitle));
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 1);
    });
  });
}