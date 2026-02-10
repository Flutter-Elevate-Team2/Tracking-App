import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/controller/session_controller.dart';

@GenerateMocks([SharedPreferences])
import 'session_controller_test.mocks.dart';

void main() {
  late SessionController sessionController;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    when(mockPrefs.remove(any)).thenAnswer((_) async => true);
    when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
    sessionController = SessionController(mockPrefs);
  });

  tearDown(() {
    sessionController.dispose();
  });

  group('SessionController', () {
    test('expireSession emits event and removes token', () async {
      expectLater(sessionController.onSessionExpired, emits(null));
      await sessionController.expireSession();
      verify(mockPrefs.remove(ApiConstants.tokenKey)).called(1);
    });

    test('notifyLogin emits event', () async {
      expectLater(sessionController.onLogin, emits(null));
      sessionController.notifyLogin();
    });

    test('notifyLogout emits reason and removes token', () async {
      expectLater(sessionController.onLogout, emits(SessionEndReason.logout));

      await sessionController.notifyLogout(SessionEndReason.logout);

      verify(mockPrefs.remove(ApiConstants.tokenKey)).called(1);
    });

    test('multiple listeners receive events (broadcast)', () async {
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
  });
}
