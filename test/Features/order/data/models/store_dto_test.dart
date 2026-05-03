import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/store_dto.dart';

void main() {
  group('Store DTO JSON Tests', () {
    final tStoreJson = {
      "name": "Flower Garden",
      "image": "store_preview.png",
      "address": "90th Street, Fifth Settlement",
      "phoneNumber": "01020304050",
      "latLong": "30.0444,31.2357"
    };

    final tStore = Store(
      name: "Flower Garden",
      image: "store_preview.png",
      address: "90th Street, Fifth Settlement",
      phoneNumber: "01020304050",
      latLong: "30.0444,31.2357",
    );

    test('fromJson should return a valid Store object', () {
      // Act
      final result = Store.fromJson(tStoreJson);

      // Assert
      expect(result, isA<Store>());
      expect(result.name, tStore.name);
      expect(result.phoneNumber, tStore.phoneNumber);
      expect(result.latLong, tStore.latLong);
      expect(result.address, tStore.address);
    });

    test('toJson should return a proper Map containing store data', () {
      // Act
      final result = tStore.toJson();

      // Assert
      expect(result['name'], tStoreJson['name']);
      expect(result['image'], tStoreJson['image']);
      expect(result['phoneNumber'], tStoreJson['phoneNumber']);
      expect(result['latLong'], tStoreJson['latLong']);
    });

    test('should handle null fields in Store gracefully', () {
      // Arrange:
      final emptyStore = Store(name: "New Branch");

      // Act
      final json = emptyStore.toJson();

      // Assert
      expect(json['name'], "New Branch");
      expect(json['address'], isNull);
      expect(json['latLong'], isNull);
    });
  });
}