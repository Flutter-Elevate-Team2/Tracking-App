import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/controller/session_controller.dart';

@GenerateMocks([SharedPreferences])
import 'session_controller_test.mocks.dart';

void main() {
  late SessionController sessionController;
  late MockSharedPreferences mockPrefs;

  final testUser = DriverEntity(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@test.com',
    phone: '123',
    role: 'driver',
    gender: 'male',
    photo: 'photo',
    country: 'country',
    vehicleType: 'vehicleType',
    vehicleNumber: 'vehicleNumber',
    vehicleLicense: 'vehicleLicense',
    nid: 'nid',
    nidImg: 'nidImg',
  );

  setUp(() {
    mockPrefs = MockSharedPreferences();
    sessionController = SessionController(mockPrefs);
  });

  tearDown(() {
    sessionController.dispose();
  });

  group('SessionController - user management', () {
    test('user is null initially', () {
      expect(sessionController.user, isNull);
    });

    test('saveUser stores user and getter returns it', () {
      sessionController.saveUser(testUser);

      expect(sessionController.user, testUser);
      expect(sessionController.user?.firstName, 'John');
    });

    test('saveUser overwrites previous user', () {
      sessionController.saveUser(testUser);

      final newUser = DriverEntity(
        id: '2',
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@test.com',
        phone: '456',
        role: 'driver',
        gender: 'female',
        photo: 'photo2',
        country: 'country2',
        vehicleType: 'vehicleType2',
        vehicleNumber: 'vehicleNumber2',
        vehicleLicense: 'vehicleLicense2',
        nid: 'nid2',
        nidImg: 'nidImg2',
      );
      sessionController.saveUser(newUser);

      expect(sessionController.user?.firstName, 'Jane');
      expect(sessionController.user?.id, '2');
    });
  });

  group('SessionController - updateSessionAuth', () {
    test('saves new token to SharedPreferences', () async {
      when(
        mockPrefs.setString(ApiConstants.tokenKey, 'new_token'),
      ).thenAnswer((_) async => true);

      await sessionController.updateSessionAuth('new_token');

      verify(mockPrefs.setString(ApiConstants.tokenKey, 'new_token')).called(1);
    });
  });

  group('SessionController - expireSession', () {
    test('removes token from SharedPreferences', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      await sessionController.expireSession();

      verify(mockPrefs.remove(ApiConstants.tokenKey)).called(1);
    });

    test('clears current user', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      sessionController.saveUser(testUser);
      expect(sessionController.user, isNotNull);

      await sessionController.expireSession();

      expect(sessionController.user, isNull);
    });

    test('emits session expired event', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      expectLater(sessionController.onSessionExpired, emits(null));
      await sessionController.expireSession();
    });
  });

  group('SessionController - notifyLogin', () {
    test('emits login event', () async {
      expectLater(sessionController.onLogin, emits(null));
      sessionController.notifyLogin();
    });
  });

  group('SessionController - notifyLogout', () {
    test('removes token from SharedPreferences', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      await sessionController.notifyLogout(SessionEndReason.logout);

      verify(mockPrefs.remove(ApiConstants.tokenKey)).called(1);
    });

    test('clears current user', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      sessionController.saveUser(testUser);
      expect(sessionController.user, isNotNull);

      await sessionController.notifyLogout(SessionEndReason.logout);

      expect(sessionController.user, isNull);
    });

    test('emits logout reason', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      expectLater(sessionController.onLogout, emits(SessionEndReason.logout));
      await sessionController.notifyLogout(SessionEndReason.logout);
    });

    test('emits guest reason', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      expectLater(sessionController.onLogout, emits(SessionEndReason.guest));
      await sessionController.notifyLogout(SessionEndReason.guest);
    });

    test('emits passwordChanged reason', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      expectLater(
        sessionController.onLogout,
        emits(SessionEndReason.passwordChanged),
      );
      await sessionController.notifyLogout(SessionEndReason.passwordChanged);
    });
  });

  group('SessionController - broadcast streams', () {
    test('multiple listeners receive login events', () async {
      int listener1Count = 0;
      int listener2Count = 0;

      final sub1 = sessionController.onLogin.listen((_) => listener1Count++);
      final sub2 = sessionController.onLogin.listen((_) => listener2Count++);

      sessionController.notifyLogin();

      await Future.delayed(Duration.zero);

      expect(listener1Count, 1);
      expect(listener2Count, 1);

      await sub1.cancel();
      await sub2.cancel();
    });

    test('multiple listeners receive logout events', () async {
      when(
        mockPrefs.remove(ApiConstants.tokenKey),
      ).thenAnswer((_) async => true);

      int listener1Count = 0;
      int listener2Count = 0;

      final sub1 = sessionController.onLogout.listen((_) => listener1Count++);
      final sub2 = sessionController.onLogout.listen((_) => listener2Count++);

      await sessionController.notifyLogout(SessionEndReason.logout);

      await Future.delayed(Duration.zero);

      expect(listener1Count, 1);
      expect(listener2Count, 1);

      await sub1.cancel();
      await sub2.cancel();
    });
  });
}
