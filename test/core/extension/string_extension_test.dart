import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/extension/string_extension.dart';

void main() {
  group('StringExtension toImageUrl Tests', () {
    test('should return empty string when string is empty', () {
      const String tInput = "";

      final result = tInput.toImageUrl;

      expect(result, "");
    });

    test('should return the same string when it starts with http', () {
      const String tInput = "http://example.com/image.png";

      final result = tInput.toImageUrl;

      expect(result, tInput);
    });

    test('should return the same string when it starts with https', () {
      const String tInput = "https://example.com/image.png";

      final result = tInput.toImageUrl;

      expect(result, tInput);
    });

    test('should return prefixed URL when string is a relative path', () {
      const String tInput = "uploads/flower.jpg";
      const String expectedUrl =
          "https://flower.elevateegy.com/uploads/flower.jpg";

      final result = tInput.toImageUrl;

      expect(result, expectedUrl);
    });
  });
}
