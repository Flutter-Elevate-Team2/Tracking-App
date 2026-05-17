import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/data/mapper/vehicles_mapper.dart';
import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';

void main() {
  group('VehiclesMapper', () {
    test('toEntity should map VehiclesResponse to List<VehicleEntity>', () {
      final response = VehiclesResponse(
        message: 'success',
        vehicles: [
          VehicleModel(id: '1', type: 'Car', image: 'image_url'),
          VehicleModel(id: '2', type: 'Bike', image: 'image_url2'),
        ],
      );

      final entities = response.toEntity();

      expect(entities.length, 2);
      expect(entities[0].id, '1');
      expect(entities[0].type, 'Car');
      expect(entities[0].image, 'image_url');
      expect(entities[1].id, '2');
      expect(entities[1].type, 'Bike');
      expect(entities[1].image, 'image_url2');
    });

    test('toEntity should return empty list when vehicles is null', () {
      final response = VehiclesResponse(message: 'success', vehicles: null);

      final entities = response.toEntity();

      expect(entities, isEmpty);
    });
  });
}
