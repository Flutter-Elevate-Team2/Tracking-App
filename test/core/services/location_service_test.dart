import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/core/services/location_service.dart';

void main() {
  late LocationService locationService;
  const MethodChannel channel = MethodChannel(
    'flutter.baseflow.com/geolocator',
  );

  final mockPosition = Position(
    latitude: 30.0,
    longitude: 31.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );

  setUp(() {
    locationService = LocationService();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  void mockGeolocatorChannel(Map<String, dynamic> responses) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return responses[methodCall.method];
        });
  }

  group('LocationService - 100% Coverage Tests', () {
    test('getCurrentLocation returns null if service is disabled', () async {
      mockGeolocatorChannel({'isLocationServiceEnabled': false});

      final result = await locationService.getCurrentLocation();
      expect(result, isNull);
    });

    test('getCurrentLocation returns null if permission is denied', () async {
      mockGeolocatorChannel({
        'isLocationServiceEnabled': true,
        'checkPermission': LocationPermission.denied.index,
        'requestPermission': LocationPermission.denied.index,
      });

      final result = await locationService.getCurrentLocation();
      expect(result, isNull);
    });

    test(
      'getCurrentLocation returns null if permission is deniedForever',
      () async {
        mockGeolocatorChannel({
          'isLocationServiceEnabled': true,
          'checkPermission': LocationPermission.deniedForever.index,
        });

        final result = await locationService.getCurrentLocation();
        expect(result, isNull);
      },
    );

    test(
      'getCurrentLocation returns position when everything is granted',
      () async {
        mockGeolocatorChannel({
          'isLocationServiceEnabled': true,
          'checkPermission': LocationPermission.always.index,
          'getCurrentPosition': mockPosition.toJson(),
        });

        final result = await locationService.getCurrentLocation();
        expect(result?.latitude, 30.0);
      },
    );

    test('getLocationStream returns valid stream', () {
      final stream = locationService.getLocationStream();
      expect(stream, isA<Stream<Position>>());
    });
  });
}
