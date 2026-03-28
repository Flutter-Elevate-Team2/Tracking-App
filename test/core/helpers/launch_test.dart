import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:tracking_app/core/helpers/launch.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  late MockUrlLauncher mockPlatform;

  setUpAll(() {
    registerFallbackValue(const LaunchOptions());
  });

  setUp(() {
    mockPlatform = MockUrlLauncher();
    UrlLauncherPlatform.instance = mockPlatform;

    when(
      () => mockPlatform.launchUrl(any(), any()),
    ).thenAnswer((_) async => true);
  });

  group('Launch Helpers Tests - 100% Coverage', () {
    test('launchPhone should format URI correctly', () async {
      const phoneNumber = "0123456789";

      await launchPhone(phoneNumber);

      verify(() => mockPlatform.launchUrl("tel:$phoneNumber", any())).called(1);
    });

    test(
      'launchWhatsApp should remove + and set externalApplication mode',
      () async {
        const phoneNumber = "+20123456789";
        const expectedUrl = "https://wa.me/20123456789";

        await launchWhatsApp(phoneNumber);

        final verification = verify(
          () => mockPlatform.launchUrl(expectedUrl, captureAny()),
        );

        final capturedOptions = verification.captured.first as LaunchOptions;
        expect(capturedOptions.mode, PreferredLaunchMode.externalApplication);
      },
    );
  });
}
