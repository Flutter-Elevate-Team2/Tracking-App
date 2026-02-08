import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:tracking_app/core/constants/error_strings.dart';
import 'package:tracking_app/core/handle_error/handle_error.dart';

void main() {
  group('ErrorHandler Test Cases', () {
    // --- 1. Network & Socket Errors ---
    test('SocketException returns noInternet', () {
      final error = const SocketException('No Internet');
      expect(ErrorHandler.handleError(error), ErrorStrings.noInternet);
    });

    test('HandshakeException returns badCertificate', () {
      final error = const HandshakeException('Bad certificate');
      expect(ErrorHandler.handleError(error), ErrorStrings.badCertificate);
    });

    test('TimeoutException returns connectionTimeout', () {
      final error = TimeoutException('Timeout');
      expect(ErrorHandler.handleError(error), ErrorStrings.connectionTimeout);
    });

    // --- 2. Dio Errors ---
    test('Dio connectionTimeout returns connectionTimeout', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.connectionTimeout);
    });

    test('Dio sendTimeout returns sendTimeout', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.sendTimeout,
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.sendTimeout);
    });

    test('Dio receiveTimeout returns receiveTimeout', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.receiveTimeout,
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.receiveTimeout);
    });

    test('Dio cancel returns requestCancelled', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.requestCancelled);
    });

    test('Dio connectionError returns connectionError', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.connectionError);
    });

    test('Dio badCertificate returns badCertificate', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badCertificate,
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.badCertificate);
    });

    test('Dio badResponse 400 extracts message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'message': 'Invalid data'},
        ),
      );
      expect(ErrorHandler.handleError(error), 'Invalid data');
    });

    test('Dio badResponse 404 returns notFound if no message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
          data: {},
        ),
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.notFound);
    });

    test('Dio badResponse 500 returns internalServerError', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          data: {},
        ),
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.internalServerError);
    });

    test('Dio unknown with SocketException returns noInternet', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.unknown,
        error: const SocketException('No Internet'),
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.noInternet);
    });

    test('Dio unknown with HandshakeException returns badCertificate', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.unknown,
        error: const HandshakeException('Bad certificate'),
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.badCertificate);
    });

    test('Dio unknown with generic error returns networkError', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.unknown,
        error: Exception('Other'),
      );
      expect(ErrorHandler.handleError(error), ErrorStrings.networkError);
    });

    // --- 3. Firebase Auth Errors ---
    test('FirebaseAuthException user-not-found', () {
      final error = FirebaseAuthException(code: 'user-not-found');
      expect(ErrorHandler.handleError(error), ErrorStrings.firebaseUserNotFound);
    });

    test('FirebaseAuthException weak-password', () {
      final error = FirebaseAuthException(code: 'weak-password');
      expect(ErrorHandler.handleError(error), ErrorStrings.firebaseWeakPassword);
    });

    test('FirebaseAuthException network-request-failed', () {
      final error = FirebaseAuthException(code: 'network-request-failed');
      expect(ErrorHandler.handleError(error), ErrorStrings.noInternet);
    });

    test('FirebaseAuthException unknown code returns message', () {
      final error = FirebaseAuthException(code: 'some-other-code', message: 'Unknown');
      expect(ErrorHandler.handleError(error), 'Unknown');
    });

    // --- 4. Firebase General Errors ---
    test('FirebaseException permission-denied', () {
      final error = FirebaseException(plugin: 'test', code: 'permission-denied');
      expect(ErrorHandler.handleError(error), ErrorStrings.firebasePermissionDenied);
    });

    test('FirebaseException unavailable', () {
      final error = FirebaseException(plugin: 'test', code: 'unavailable');
      expect(ErrorHandler.handleError(error), ErrorStrings.firebaseUnavailable);
    });

    test('FirebaseException network-request-failed', () {
      final error = FirebaseException(plugin: 'test', code: 'network-request-failed');
      expect(ErrorHandler.handleError(error), ErrorStrings.noInternet);
    });

    test('FirebaseException unknown code returns unknownError', () {
      final error = FirebaseException(plugin: 'test', code: 'other');
      expect(ErrorHandler.handleError(error), ErrorStrings.unknownError);
    });

    // --- 5. Local Storage Errors ---
    test('HiveError returns hiveError', () {
      final error = HiveError('Box closed');
      expect(ErrorHandler.handleError(error), ErrorStrings.hiveError);
    });

    test('PlatformException network_error returns noInternet', () {
      final error = PlatformException(code: 'network_error');
      expect(ErrorHandler.handleError(error), ErrorStrings.noInternet);
    });

    test('PlatformException other returns platformError', () {
      final error = PlatformException(code: 'other');
      expect(ErrorHandler.handleError(error), ErrorStrings.platformError);
    });

    // --- 6. TypeError & FormatException ---
    test('FormatException returns formatException', () {
      final error = const FormatException();
      expect(ErrorHandler.handleError(error), ErrorStrings.formatException);
    });

    test('Unknown Exception returns unknownError', () {
      final error = Exception('Random');
      expect(ErrorHandler.handleError(error), ErrorStrings.unknownError);
    });
  });
}
