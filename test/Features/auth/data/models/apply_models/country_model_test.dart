import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/country_model.dart';

void main() {
  group('CountryModel', () {
    final tTimezoneJson = {
      "zoneName": "Africa/Cairo",
      "gmtOffset": 7200,
      "gmtOffsetName": "UTC+02:00",
      "abbreviation": "EET",
      "tzName": "Eastern European Time",
    };

    final tCountryJson = {
      "isoCode": "EG",
      "name": "Egypt",
      "phoneCode": "+20",
      "flag": "🇪🇬",
      "currency": "EGP",
      "latitude": "26.8206",
      "longitude": "30.8025",
      "timezones": [tTimezoneJson],
    };

    final tTimezone = Timezones(
      zoneName: "Africa/Cairo",
      gmtOffset: 7200,
      gmtOffsetName: "UTC+02:00",
      abbreviation: "EET",
      tzName: "Eastern European Time",
    );

    final tCountry = CountryModel(
      isoCode: "EG",
      name: "Egypt",
      phoneCode: "+20",
      flag: "🇪🇬",
      currency: "EGP",
      latitude: "26.8206",
      longitude: "30.8025",
      timezones: [tTimezone],
    );

    test('fromJson should return valid CountryModel object', () {
      final result = CountryModel.fromJson(tCountryJson);

      expect(result, isA<CountryModel>());
      expect(result.isoCode, tCountry.isoCode);
      expect(result.name, tCountry.name);

      final timezone = result.timezones?.first;
      expect(timezone?.zoneName, tTimezone.zoneName);
    });

    test('toJson should return correct Map representation', () {
      final result = tCountry.toJson();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['isoCode'], tCountryJson['isoCode']);

      // التعديل هنا: تحويل النتيجة لـ List ثم الوصول لأول عنصر كـ Map
      final timezonesJson = result['timezones'] as List?;
      expect(timezonesJson, isNotNull);

      final tzMap = timezonesJson!.first as Map<String, dynamic>;
      expect(tzMap['zoneName'], tTimezoneJson['zoneName']);
      expect(tzMap['gmtOffset'], tTimezoneJson['gmtOffset']);
      expect(tzMap['gmtOffsetName'], tTimezoneJson['gmtOffsetName']);
      expect(tzMap['abbreviation'], tTimezoneJson['abbreviation']);
      expect(tzMap['tzName'], tTimezoneJson['tzName']);
    });

    test('should handle null fields safely', () {
      final emptyCountry = CountryModel();
      final json = emptyCountry.toJson();

      expect(json['isoCode'], null);
      expect(json['timezones'], null);
    });
  });
}