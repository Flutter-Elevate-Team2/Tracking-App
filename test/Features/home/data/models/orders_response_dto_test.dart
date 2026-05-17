import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/data/mappers/order_mapper.dart';
import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';

void main() {
  group('OrdersResponseDto', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'message': 'success',
        'metadata': {
          'currentPage': 1,
          'totalPages': 3,
          'totalItems': 30,
          'limit': 10,
        },
        'orders': [
          {
            '_id': 'order1',
            'orderNumber': '#001',
            'totalPrice': 200,
            'state': 'pending',
            'isPaid': false,
            'isDelivered': false,
            'paymentType': 'cash',
            'createdAt': '2024-01-01T00:00:00Z',
          },
        ],
      };

      final dto = OrdersResponseDto.fromJson(json);
      expect(dto.message, 'success');
      expect(dto.metadata?.currentPage, 1);
      expect(dto.metadata?.totalPages, 3);
      expect(dto.metadata?.totalItems, 30);
      expect(dto.metadata?.limit, 10);
      expect(dto.orders?.length, 1);
      expect(dto.orders?.first.id, 'order1');
    });

    test('fromJson with null metadata and orders', () {
      final dto = OrdersResponseDto.fromJson({});
      expect(dto.metadata, isNull);
      expect(dto.orders, isNull);
    });
  });

  group('MetadataDto', () {
    test('fromJson parses correctly', () {
      final json = {
        'currentPage': 2,
        'totalPages': 5,
        'totalItems': 50,
        'limit': 10,
      };
      final meta = MetadataDto.fromJson(json);
      expect(meta.currentPage, 2);
      expect(meta.totalPages, 5);
      expect(meta.totalItems, 50);
      expect(meta.limit, 10);
    });
  });

  group('OrderDto', () {
    test('fromJson with user as string (id only)', () {
      final json = {'_id': 'order1', 'user': 'userId123'};
      final dto = OrderDto.fromJson(json);
      expect(dto.user?.id, 'userId123');
      expect(dto.user?.firstName, isNull);
    });

    test('fromJson with user as object', () {
      final json = {
        '_id': 'order1',
        'user': {
          '_id': 'u1',
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john@test.com',
          'gender': 'male',
          'phone': '01234567890',
          'photo': 'photo.jpg',
        },
      };
      final dto = OrderDto.fromJson(json);
      expect(dto.user?.id, 'u1');
      expect(dto.user?.firstName, 'John');
    });

    test('fromJson with null user', () {
      final json = {'_id': 'order1', 'user': null};
      final dto = OrderDto.fromJson(json);
      expect(dto.user, isNull);
    });

    test('fromJson with order items', () {
      final json = {
        '_id': 'order1',
        'orderItems': [
          {'_id': 'item1', 'price': 50, 'quantity': 2},
        ],
      };
      final dto = OrderDto.fromJson(json);
      expect(dto.orderItems?.length, 1);
      expect(dto.orderItems?.first.id, 'item1');
    });

    test('fromJson with shipping address and store', () {
      final json = {
        '_id': 'order1',
        'shippingAddress': {
          'street': '123 Main St',
          'city': 'Cairo',
          'phone': '01234567890',
          'lat': '30.0',
          'long': '31.0',
        },
        'store': {
          'name': 'Store A',
          'image': 'store.jpg',
          'address': '456 Store St',
          'phoneNumber': '09876543210',
          'latLong': '30.0,31.0',
        },
      };
      final dto = OrderDto.fromJson(json);
      expect(dto.shippingAddress?.street, '123 Main St');
      expect(dto.store?.name, 'Store A');
    });
  });

  group('OrderItemDto', () {
    test('fromJson with product as string (id only)', () {
      final json = {
        '_id': 'item1',
        'product': 'prodId123',
        'price': 100,
        'quantity': 1,
      };
      final dto = OrderItemDto.fromJson(json);
      expect(dto.product?.id, 'prodId123');
    });

    test('fromJson with product as object', () {
      final json = {
        '_id': 'item1',
        'product': {
          '_id': 'p1',
          'title': 'Product A',
          'imgCover': 'img.jpg',
          'price': 100,
          'slug': 'product-a',
          'description': 'A product',
        },
      };
      final dto = OrderItemDto.fromJson(json);
      expect(dto.product?.id, 'p1');
      expect(dto.product?.title, 'Product A');
    });

    test('fromJson with null product', () {
      final json = {'_id': 'item1', 'product': null};
      final dto = OrderItemDto.fromJson(json);
      expect(dto.product, isNull);
    });
  });

  group('ProductDto', () {
    test('fromJson parses all fields', () {
      final json = {
        '_id': 'p1',
        'title': 'Product A',
        'slug': 'product-a',
        'description': 'desc',
        'imgCover': 'img.jpg',
        'images': ['img1.jpg', 'img2.jpg'],
        'price': 100,
        'priceAfterDiscount': 80,
        'quantity': 5,
      };
      final dto = ProductDto.fromJson(json);
      expect(dto.id, 'p1');
      expect(dto.title, 'Product A');
      expect(dto.imgCover, 'img.jpg');
      expect(dto.price, 100);
      expect(dto.images?.length, 2);
    });
  });

  group('OrderResponseMapper extensions', () {
    test('toHomeOrdersEntity maps correctly', () {
      final dto = OrdersResponseDto(
        message: 'ok',
        metadata: MetadataDto(totalPages: 2, currentPage: 1),
        orders: [OrderDto(id: 'o1', orderNumber: '#1', totalPrice: 100)],
      );
      final entity = dto.toHomeOrdersEntity();
      expect(entity.orders.length, 1);
      expect(entity.orders.first.id, 'o1');
      expect(entity.totalPages, 2);
    });

    test('toHomeOrdersEntity with null orders returns empty list', () {
      final dto = OrdersResponseDto(metadata: MetadataDto(totalPages: 1));
      final entity = dto.toHomeOrdersEntity();
      expect(entity.orders, isEmpty);
    });

    test('toHomeOrdersEntity with null metadata defaults to totalPages=1', () {
      final dto = OrdersResponseDto(orders: []);
      final entity = dto.toHomeOrdersEntity();
      expect(entity.totalPages, 1);
    });

    test('UserDto.toEntity maps photo with base URL when non-empty', () {
      final dto = UserDto(
        id: 'u1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@test.com',
        phone: '000',
        photo: 'photo.jpg',
      );
      final entity = dto.toEntity();
      expect(entity.photo, contains('https://flower.elevateegy.com/uploads/'));
    });

    test('UserDto.toEntity uses empty string for null/empty photo', () {
      final dto = UserDto(
        id: 'u1',
        firstName: 'John',
        lastName: 'Doe',
        email: '',
        phone: '',
        photo: null,
      );
      final entity = dto.toEntity();
      expect(entity.photo, '');
    });

    test('OrderDto.toEntity maps all fields including createdAt', () {
      final dto = OrderDto(
        id: 'o1',
        createdAt: '2024-06-01T00:00:00Z',
        shippingAddress: ShippingAddressDto(
          street: 'St',
          city: 'City',
          lat: '30.0',
          long: '31.0',
        ),
        store: StoreDto(name: 'Store', image: 'img.jpg'),
      );
      final entity = dto.toEntity();
      expect(entity.id, 'o1');
      expect(entity.createdAt, isNotNull);
      expect(entity.shippingAddress?.street, 'St');
      expect(entity.store?.name, 'Store');
    });

    test('OrderItemDto with product object toEntity maps correctly', () {
      final dto = OrderItemDto(
        id: 'i1',
        product: ProductDto(id: 'p1', title: 'Prod', imgCover: 'img.jpg'),
        price: 50,
        quantity: 2,
      );
      final entity = dto.toEntity();
      expect(entity.id, 'i1');
      expect(entity.product?.id, 'p1');
      expect(entity.price, 50);
    });
  });
}
