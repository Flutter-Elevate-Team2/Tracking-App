import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/api/api_client/api_client.dart';
import 'package:tracking_app/Features/track_order/api/remote_data_source_impl/map_remote_data_source_impl.dart';

import 'map_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([MapboxApiClient])
void main() {
  late MapRemoteDataSourceImpl dataSource;
  late MockMapboxApiClient mockApiClient;

  setUp(() async {
    mockApiClient = MockMapboxApiClient();
    dataSource = MapRemoteDataSourceImpl(mockApiClient);
    dotenv.clean();
    await dotenv.load(mergeWith: {'MAPBOX_ACCESS_TOKEN': 'fake_token'});
  });

  group('MapRemoteDataSourceImpl Tests', () {
    final startPos = mapbox.Position(31.0, 30.0);
    final endPos = mapbox.Position(31.2, 30.2);
    final expectedCoordinates =
        "${startPos.lng},${startPos.lat};${endPos.lng},${endPos.lat}";

    test('getRoute returns a list of mapbox Positions on success', () async {
      final mockResponse = {
        'routes': [
          {
            'geometry': {
              'coordinates': [
                [31.0, 30.0],
                [31.1, 30.1],
                [31.2, 30.2],
              ],
            },
          },
        ],
      };

      when(
        mockApiClient.getDirections(
          any, // coordinates
          any, // geometries
          any, // overview
          any, // access_token
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await dataSource.getRoute(startPos, endPos);

      expect(result, isA<List<mapbox.Position>>());
      expect(result.length, 3);
      expect(result[0].lng, 31.0);
      expect(result[2].lat, 30.2);

      verify(
        mockApiClient.getDirections(
          expectedCoordinates,
          "geojson",
          "full",
          "fake_token",
        ),
      ).called(1);
    });

    test(
      'getRoute should use empty string if dotenv token is missing',
      () async {
        dotenv.env.remove('MAPBOX_ACCESS_TOKEN');

        when(mockApiClient.getDirections(any, any, any, any)).thenAnswer(
          (_) async => {
            'routes': [
              {
                'geometry': {
                  'coordinates': [
                    [0.0, 0.0],
                  ],
                },
              },
            ],
          },
        );

        await dataSource.getRoute(startPos, endPos);

        verify(mockApiClient.getDirections(any, any, any, "")).called(1);
      },
    );

    test('getRoute throws exception when API fails', () async {
      when(
        mockApiClient.getDirections(any, any, any, any),
      ).thenThrow(Exception("Network Error"));

      expect(() => dataSource.getRoute(startPos, endPos), throwsException);
    });
  });
}
