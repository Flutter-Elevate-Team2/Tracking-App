import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/data/mappers/order_mapper.dart';
import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';

void main() {
  group('OrderMapper Tests', () {
    test('OrdersResponseDto.toEntity() maps correctly', () {
      final dto = OrdersResponseDto(
        orders: [
          OrderDto(id: '1', orderNumber: '#1'),
          OrderDto(id: '2', orderNumber: '#2'),
        ],
      );

      final entities = dto.toEntity();

      expect(entities.length, 2);
      expect(entities[0].id, '1');
      expect(entities[1].id, '2');
    });

    test('OrderDto.toEntity() maps all fields correctly', () {
      final dto = OrderDto(
        id: '123',
        orderNumber: '#001',
        totalPrice: 1000,
        paymentType: 'cash',
        isPaid: true,
        isDelivered: false,
        state: 'pending',
        user: UserDto(
          id: 'u1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@test.com',
          phone: '12345',
          photo: 'photo_url',
        ),
        orderItems: [
          OrderItemDto(
            id: 'item1',
            price: 500,
            quantity: 2,
            product: ProductDto(
              id: 'p1',
              title: 'Product 1',
              imgCover: 'img_url',
              price: 500,
            ),
          ),
        ],
        shippingAddress: ShippingAddressDto(
          street: 'Main St',
          city: 'Cairo',
          phone: '123456',
          lat: '30.0',
          long: '31.0',
        ),
        store: StoreDto(
          name: 'My Store',
          image: 'store_url',
          address: 'Store Addr',
          phoneNumber: '98765',
          latLong: '30,31',
        ),
      );

      final entity = dto.toEntity();

      expect(entity.id, '123');
      expect(entity.orderNumber, '#001');
      expect(entity.totalPrice, 1000);
      expect(entity.paymentType, 'cash');
      expect(entity.isPaid, true);
      expect(entity.isDelivered, false);
      expect(entity.state, 'pending');

      expect(entity.user?.id, 'u1');
      expect(entity.user?.fullName, 'John Doe');

      expect(entity.orderItems?.length, 1);
      expect(entity.orderItems?[0].id, 'item1');
      expect(entity.orderItems?[0].product?.title, 'Product 1');

      expect(entity.shippingAddress?.street, 'Main St');
      expect(entity.shippingAddress?.lat, '30.0');

      expect(entity.store?.name, 'My Store');
    });

    test('UserDto.toEntity() maps correctly with defaults', () {
      final dto = UserDto(id: 'u1');
      final entity = dto.toEntity();

      expect(entity.id, 'u1');
      expect(entity.firstName, '');
      expect(entity.lastName, '');
      expect(entity.fullName, ' ');
    });
  });
}
