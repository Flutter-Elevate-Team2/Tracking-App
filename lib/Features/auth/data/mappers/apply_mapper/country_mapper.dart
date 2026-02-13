import 'package:tracking_app/Features/auth/data/models/apply_models/country_model.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/country_entities.dart';

extension CountryMapper on CountryModel {
  CountryEntity toEntity() {
    return CountryEntity(
      isoCode: isoCode,
      name: name,
      phoneCode: phoneCode,
      flag:flag,
    );
  }
}

extension CountryListMapper on List<CountryModel> {
  List<CountryEntity> toEntityList() {
    return map((e) => e.toEntity()).toList();
  }
}
