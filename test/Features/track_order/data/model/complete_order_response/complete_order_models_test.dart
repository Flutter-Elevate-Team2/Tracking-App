import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/order_item.dart';
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/shipping_address.dart';

void main() {
  group('OrderItem', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        '_id': 'item1',
        'product': 'prod1',
        'price': 100,
        'quantity': 2,
      };
      final item = OrderItem.fromJson(json);
      expect(item.id, 'item1');
      expect(item.product, 'prod1');
      expect(item.price, 100);
      expect(item.quantity, 2);
    });

    test('fromJson with null fields', () {
      final item = OrderItem.fromJson({});
      expect(item.id, isNull);
      expect(item.product, isNull);
      expect(item.price, isNull);
      expect(item.quantity, isNull);
    });

    test('toJson serializes correctly', () {
      final item = OrderItem(
        id: 'item1',
        product: 'prod1',
        price: 100,
        quantity: 2,
      );
      final json = item.toJson();
      expect(json['_id'], 'item1');
      expect(json['product'], 'prod1');
      expect(json['price'], 100);
      expect(json['quantity'], 2);
    });

    test('constructor creates instance with all fields', () {
      final item = OrderItem(id: 'i1', product: 'p1', price: 50, quantity: 1);
      expect(item.id, 'i1');
      expect(item.product, 'p1');
      expect(item.price, 50);
      expect(item.quantity, 1);
    });
  });

  group('ShippingAddress', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'street': '123 Main St',
        'city': 'Cairo',
        'phone': '01234567890',
        'lat': '30.0',
        'long': '31.0',
      };
      final addr = ShippingAddress.fromJson(json);
      expect(addr.street, '123 Main St');
      expect(addr.city, 'Cairo');
      expect(addr.phone, '01234567890');
      expect(addr.lat, '30.0');
      expect(addr.long, '31.0');
    });

    test('fromJson with null fields', () {
      final addr = ShippingAddress.fromJson({});
      expect(addr.street, isNull);
      expect(addr.city, isNull);
      expect(addr.phone, isNull);
      expect(addr.lat, isNull);
      expect(addr.long, isNull);
    });

    test('toJson serializes correctly', () {
      final addr = ShippingAddress(
        street: '123 Main St',
        city: 'Cairo',
        phone: '01234567890',
        lat: '30.0',
        long: '31.0',
      );
      final json = addr.toJson();
      expect(json['street'], '123 Main St');
      expect(json['city'], 'Cairo');
      expect(json['phone'], '01234567890');
      expect(json['lat'], '30.0');
      expect(json['long'], '31.0');
    });

    test('constructor creates instance with all fields', () {
      final addr = ShippingAddress(
        street: 'St',
        city: 'City',
        phone: '000',
        lat: '1.0',
        long: '2.0',
      );
      expect(addr.street, 'St');
      expect(addr.city, 'City');
    });
  });
}
