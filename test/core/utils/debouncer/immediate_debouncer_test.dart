import 'package:tracking_app/core/utils/debouncer/immediate_debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImmediateDebouncer', () {
    test('run executes action immediately', () {
      bool called = false;
      final debouncer = ImmediateDebouncer();

      debouncer.run(() {
        called = true;
      });

      expect(called, isTrue);
    });

    test('dispose does not throw', () {
      final debouncer = ImmediateDebouncer();

      expect(() => debouncer.dispose(), returnsNormally);
    });

    test('run after dispose still executes action', () {
      bool called = false;
      final debouncer = ImmediateDebouncer();

      debouncer.dispose();
      debouncer.run(() {
        called = true;
      });

      expect(called, isTrue);
    });
  });
}
