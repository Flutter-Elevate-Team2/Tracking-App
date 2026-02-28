import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tracking_app/Features/track_order/data/remote_data_source_contract/map_remote_data_source_contract.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_directions_use_case.dart';
import 'get_directions_use_case_test.mocks.dart';

@GenerateMocks([MapRemoteDataSourceContract])

void main() {
  late GetDirectionsUseCase useCase;
  late MockMapRemoteDataSourceContract mockRepository;

  setUp(() {
    mockRepository = MockMapRemoteDataSourceContract();
    useCase = GetDirectionsUseCase(mockRepository);
  });

  final tStart = mapbox.Position(31.2357, 30.0444); // Cairo
  final tEnd = mapbox.Position(31.2585, 30.0626);
  final tRoutePoints = [
    mapbox.Position(31.2357, 30.0444),
    mapbox.Position(31.2585, 30.0626),
  ];

  test(
    'should get route positions from the repository',
        () async {
      when(mockRepository.getRoute(any, any))
          .thenAnswer((_) async => tRoutePoints);

      final result = await useCase(tStart, tEnd);

      expect(result, tRoutePoints);
      verify(mockRepository.getRoute(tStart, tEnd));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should throw an exception when repository fails',
        () async {
      // Arrange
      when(mockRepository.getRoute(any, any))
          .thenThrow(Exception('Server Error'));

      // Act & Assert
      expect(() => useCase(tStart, tEnd), throwsException);
    },
  );
}