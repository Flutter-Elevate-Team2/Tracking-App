import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';

void main() {
  group('OrderUserEntity', () {
    const tUser = OrderUserEntity(
      id: 'u1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      phone: '01234567890',
      photo: 'https://photo.url',
    );

    test('fullName returns firstName + lastName', () {
      expect(tUser.fullName, 'John Doe');
    });

    test('props contains all fields', () {
      expect(tUser.props, [
        'u1',
        'John',
        'Doe',
        'john@example.com',
        '01234567890',
        'https://photo.url',
      ]);
    });

    test('equality works correctly', () {
      const user2 = OrderUserEntity(
        id: 'u1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '01234567890',
        photo: 'https://photo.url',
      );
      expect(tUser, equals(user2));
    });
  });

  group('OrderEntity', () {
    final tOrder = OrderEntity(
      id: 'o1',
      orderNumber: '#001',
      totalPrice: 150,
      state: 'pending',
      isPaid: false,
      isDelivered: false,
      paymentType: 'cash',
      createdAt: DateTime(2024, 1, 1),
    );

    test('props contains all fields', () {
      expect(tOrder.id, 'o1');
      expect(tOrder.orderNumber, '#001');
      expect(tOrder.totalPrice, 150);
    });

    test('two equal OrderEntity instances are equal', () {
      final order2 = OrderEntity(
        id: 'o1',
        orderNumber: '#001',
        totalPrice: 150,
        state: 'pending',
        isPaid: false,
        isDelivered: false,
        paymentType: 'cash',
        createdAt: DateTime(2024, 1, 1),
      );
      expect(tOrder, equals(order2));
    });

    test('different orders are not equal', () {
      const order2 = OrderEntity(id: 'o2');
      expect(tOrder, isNot(equals(order2)));
    });
  });

  group('OrderItemEntity', () {
    const tItem = OrderItemEntity(id: 'i1', price: 50, quantity: 2);

    test('props contains all fields', () {
      expect(tItem.props, [null, 50, 2, 'i1']);
    });

    test('two equal items are equal', () {
      const item2 = OrderItemEntity(id: 'i1', price: 50, quantity: 2);
      expect(tItem, equals(item2));
    });
  });

  group('ProductEntity', () {
    const tProduct = ProductEntity(
      id: 'p1',
      title: 'Product A',
      imgCover: 'https://img.url',
      price: 100,
    );

    test('props contains all fields', () {
      expect(tProduct.props, ['p1', 'Product A', 'https://img.url', 100]);
    });

    test('equality works correctly', () {
      const product2 = ProductEntity(
        id: 'p1',
        title: 'Product A',
        imgCover: 'https://img.url',
        price: 100,
      );
      expect(tProduct, equals(product2));
    });
  });

  group('ShippingAddressEntity', () {
    const tAddress = ShippingAddressEntity(
      street: '123 Main St',
      city: 'Cairo',
      phone: '01234567890',
      lat: '30.0',
      long: '31.0',
    );

    test('props contains all fields', () {
      expect(tAddress.props, [
        '123 Main St',
        'Cairo',
        '01234567890',
        '30.0',
        '31.0',
      ]);
    });

    test('equality works correctly', () {
      const addr2 = ShippingAddressEntity(
        street: '123 Main St',
        city: 'Cairo',
        phone: '01234567890',
        lat: '30.0',
        long: '31.0',
      );
      expect(tAddress, equals(addr2));
    });
  });

  group('StoreEntity', () {
    const tStore = StoreEntity(
      name: 'Store A',
      image: 'https://store.url',
      address: '456 Store St',
      phoneNumber: '09876543210',
      latLong: '30.0,31.0',
    );

    test('props contains all fields', () {
      expect(tStore.props, [
        'Store A',
        'https://store.url',
        '456 Store St',
        '09876543210',
        '30.0,31.0',
      ]);
    });

    test('equality works correctly', () {
      const store2 = StoreEntity(
        name: 'Store A',
        image: 'https://store.url',
        address: '456 Store St',
        phoneNumber: '09876543210',
        latLong: '30.0,31.0',
      );
      expect(tStore, equals(store2));
    });
  });

  group('HomeOrdersEntity', () {
    final tOrders = HomeOrdersEntity(
      orders: [const OrderEntity(id: 'o1')],
      totalPages: 3,
      currentPage: 2,
    );

    test('default currentPage is 1', () {
      const entity = HomeOrdersEntity(orders: [], totalPages: 1);
      expect(entity.currentPage, 1);
    });

    test('props contains all fields', () {
      expect(tOrders.totalPages, 3);
      expect(tOrders.currentPage, 2);
      expect(tOrders.orders.length, 1);
    });

    test('equality works correctly', () {
      final e2 = HomeOrdersEntity(
        orders: [const OrderEntity(id: 'o1')],
        totalPages: 3,
        currentPage: 2,
      );
      expect(tOrders, equals(e2));
    });
  });
}
