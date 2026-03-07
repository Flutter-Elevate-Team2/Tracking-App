import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/complete_order_response.dart';
import 'package:tracking_app/Features/track_order/data/remote_data_source_contract/map_remote_data_source_contract.dart';
import 'package:tracking_app/Features/track_order/data/repo/track_order_repo_imple.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'track_order_repo_imple_test.mocks.dart';

@GenerateMocks([MapRemoteDataSourceContract])
void main() {
  late TrackOrderRepoImple repository;
  late MockMapRemoteDataSourceContract mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockMapRemoteDataSourceContract();
    repository = TrackOrderRepoImple(mockRemoteDataSource);
  });

  group('TrackOrderRepoImple Test', () {
    const orderId = '123';
    final requestBody = {"state": "completed"};

    test(
      'changeOrderState should return SuccessResponse when remote data source succeeds',
      () async {
        // Arrange
        final tResponse = CompleteOrderResponse(message: 'Success');
        when(
          mockRemoteDataSource.changeOrderState(orderId, requestBody),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.changeOrderState(orderId);

        // Assert
        expect(result, isA<SuccessResponse<CompleteOrderEntity>>());
        final successResult = result as SuccessResponse<CompleteOrderEntity>;
        expect(successResult.data.message, 'Success');
        verify(
          mockRemoteDataSource.changeOrderState(orderId, requestBody),
        ).called(1);
      },
    );

    test(
      'changeOrderState should return ErrorResponse when remote data source throws exception',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.changeOrderState(orderId, requestBody),
        ).thenThrow(Exception('Server Error'));

        // Act
        final result = await repository.changeOrderState(orderId);

        // Assert
        expect(result, isA<ErrorResponse<CompleteOrderEntity>>());
        verify(
          mockRemoteDataSource.changeOrderState(orderId, requestBody),
        ).called(1);
      },
    );
  });
}
