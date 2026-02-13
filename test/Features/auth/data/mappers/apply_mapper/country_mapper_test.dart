import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/data/mappers/apply_mapper/country_mapper.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/country_model.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/country_entities.dart';

void main() {

    test('toEntity should convert CountryModel to CountryEntity correctly', () {
      // Arrange
      final countryResponse = CountryModel(
        currency: "",
        flag: "",
        isoCode: "",
        latitude: "",
        longitude: "",
        name: "",
        phoneCode: "",
        timezones: []
      );

      // Act
      final entity = countryResponse.toEntity();

      // Assert
      expect(entity, isA<CountryEntity>());
      expect(entity.name, countryResponse.name);
      expect(entity.flag, countryResponse.flag);
      expect(entity.isoCode, countryResponse.isoCode);
      expect(entity.phoneCode, countryResponse.phoneCode);
    });
}
