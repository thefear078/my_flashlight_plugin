import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('my_flashlight_plugin');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  var torch = false;
  var hasFlash = true;

  setUp(() {
    torch = false;
    hasFlash = true;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (!hasFlash) throw PlatformException(code: 'NO_FLASH', message: 'no');
      if (call.method == 'toggle') return torch = !torch;
      if (call.method == 'isAvailable') return true;
      return null;
    });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('toggle on Android switches state', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(await MyFlashlightPlugin.toggle(), isTrue);
    expect(await MyFlashlightPlugin.toggle(), isFalse);
  });

  test('device without flash -> FlashlightUnavailableException', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    hasFlash = false;
    await expectLater(
      MyFlashlightPlugin.toggle(),
      throwsA(isA<FlashlightUnavailableException>()),
    );
  });

  test('iOS -> FlashlightUnsupportedException, no channel call', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await expectLater(
      MyFlashlightPlugin.toggle(),
      throwsA(isA<FlashlightUnsupportedException>()),
    );
    expect(await MyFlashlightPlugin.isAvailable(), isFalse);
    expect(torch, isFalse);
  });
}
