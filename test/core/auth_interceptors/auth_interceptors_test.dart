import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/auth_interceptors/auth_interceptors.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/controller/session_controller.dart';

import 'auth_interceptors_test.mocks.dart';

@GenerateMocks([
  SharedPreferences,
  SessionController,
  RequestInterceptorHandler,
  ErrorInterceptorHandler,
])
void main() {
  late AuthInterceptor authInterceptor;
  late MockSharedPreferences mockPrefs;
  late MockSessionController mockSessionController;
  late MockRequestInterceptorHandler mockRequestHandler;
  late MockErrorInterceptorHandler mockErrorHandler;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockSessionController = MockSessionController();
    mockRequestHandler = MockRequestInterceptorHandler();
    mockErrorHandler = MockErrorInterceptorHandler();

    // Register mock SessionController in GetIt so AuthInterceptor can lazily
    // resolve it (we broke the circular dep by removing it from the constructor).
    final getIt = GetIt.instance;
    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
    getIt.registerSingleton<SessionController>(mockSessionController);

    authInterceptor = AuthInterceptor(mockPrefs);
  });

  tearDown(() {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
  });

  group('AuthInterceptor', () {
    group('onRequest', () {
      test(
        'adds Authorization header for private paths when token exists',
        () async {
          // Arrange
          final options = RequestOptions(path: '/private/endpoint');
          when(mockPrefs.reload()).thenAnswer((_) async {});
          when(
            mockPrefs.getString(ApiConstants.tokenKey),
          ).thenReturn('test_token');

          // Act
          authInterceptor.onRequest(options, mockRequestHandler);
          await Future.delayed(Duration.zero); // For async reload

          // Assert
          verify(mockPrefs.getString(ApiConstants.tokenKey));
          expect(options.headers['Authorization'], 'Bearer test_token');
          verify(mockRequestHandler.next(options));
        },
      );

      test('does not add Authorization header for public paths', () async {
        // Arrange
        final options = RequestOptions(path: ApiConstants.login); // Public path

        // Act
        authInterceptor.onRequest(options, mockRequestHandler);

        // Assert
        verifyNever(mockPrefs.getString(any));
        expect(options.headers['Authorization'], isNull);
        verify(mockRequestHandler.next(options));
      });

      test('does not add header if token is null', () async {
        // Arrange
        final options = RequestOptions(path: '/private/endpoint');
        when(mockPrefs.reload()).thenAnswer((_) async {});
        when(mockPrefs.getString(ApiConstants.tokenKey)).thenReturn(null);

        // Act
        authInterceptor.onRequest(options, mockRequestHandler);
        await Future.delayed(Duration.zero);

        // Assert
        expect(options.headers['Authorization'], isNull);
        verify(mockRequestHandler.next(options));
      });
    });

    group('onError', () {
      test('triggers logout on 401 for private path', () async {
        // Arrange
        final requestOptions = RequestOptions(path: '/private/endpoint');
        final response = Response(
          requestOptions: requestOptions,
          statusCode: 401,
        );
        final error = DioException(
          requestOptions: requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );

        when(
          mockPrefs.remove(ApiConstants.tokenKey),
        ).thenAnswer((_) async => true);

        // Act
        authInterceptor.onError(error, mockErrorHandler);
        await Future.delayed(Duration.zero); // For async logout

        // Assert
        verify(mockPrefs.remove(ApiConstants.tokenKey)).called(1);
        verify(mockSessionController.expireSession()).called(1);
        verify(mockErrorHandler.next(error));
      });

      test('does not trigger logout on 401 for public path', () async {
        // Arrange
        final requestOptions = RequestOptions(path: ApiConstants.login);
        final response = Response(
          requestOptions: requestOptions,
          statusCode: 401,
        );
        final error = DioException(
          requestOptions: requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );

        // Act
        authInterceptor.onError(error, mockErrorHandler);

        // Assert
        verifyNever(mockPrefs.remove(any));
        verifyNever(mockSessionController.expireSession());
        verify(mockErrorHandler.next(error));
      });

      test('does not trigger logout for non-401 errors', () async {
        // Arrange
        final requestOptions = RequestOptions(path: '/private/endpoint');
        final response = Response(
          requestOptions: requestOptions,
          statusCode: 500,
        );
        final error = DioException(
          requestOptions: requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );

        // Act
        authInterceptor.onError(error, mockErrorHandler);

        // Assert
        verifyNever(mockPrefs.remove(any));
        verifyNever(mockSessionController.expireSession());
        verify(mockErrorHandler.next(error));
      });
    });
  });
}
