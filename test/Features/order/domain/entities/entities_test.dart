import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/domain/entities/metadata_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    const tUser = UserEntity(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      gender: 'male',
      phone: '01234567890',
      photo: 'https://photo.url',
      passwordChangedAt: '2024-01-01',
      passwordResetCode: 'abc123',
      passwordResetExpires: '2024-12-31',
      resetCodeVerified: true,
    );

    test('props returns all fields', () {
      expect(tUser.props, [
        '1',
        'John',
        'Doe',
        'john@example.com',
        'male',
        '01234567890',
        'https://photo.url',
        '2024-01-01',
        'abc123',
        '2024-12-31',
        true,
      ]);
    });

    test('two equal UserEntity instances are equal', () {
      const user2 = UserEntity(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        gender: 'male',
        phone: '01234567890',
        photo: 'https://photo.url',
        passwordChangedAt: '2024-01-01',
        passwordResetCode: 'abc123',
        passwordResetExpires: '2024-12-31',
        resetCodeVerified: true,
      );
      expect(tUser, equals(user2));
    });

    test('different UserEntity instances are not equal', () {
      const user2 = UserEntity(id: '2', firstName: 'Jane');
      expect(tUser, isNot(equals(user2)));
    });

    test('null fields are allowed', () {
      const user = UserEntity();
      expect(user.id, isNull);
      expect(user.firstName, isNull);
      expect(user.resetCodeVerified, isNull);
    });
  });

  group('MetadataEntity', () {
    const tMeta = MetadataEntity(
      currentPage: 1,
      totalPages: 5,
      limit: 10,
      totalItems: 50,
    );

    test('props contains all fields', () {
      expect(tMeta.props, [1, 5, 10, 50]);
    });

    test('two equal MetadataEntity instances are equal', () {
      const meta2 = MetadataEntity(
        currentPage: 1,
        totalPages: 5,
        limit: 10,
        totalItems: 50,
      );
      expect(tMeta, equals(meta2));
    });

    test('different MetadataEntity instances are not equal', () {
      const meta2 = MetadataEntity(currentPage: 2, totalPages: 3);
      expect(tMeta, isNot(equals(meta2)));
    });

    test('null fields are allowed', () {
      const meta = MetadataEntity();
      expect(meta.currentPage, isNull);
      expect(meta.totalPages, isNull);
      expect(meta.limit, isNull);
      expect(meta.totalItems, isNull);
    });
  });
}
