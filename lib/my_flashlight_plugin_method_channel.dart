import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin_platform_interface.dart';
import 'package:my_flashlight_plugin/src/exceptions.dart';

/// Реалізація через MethodChannel (Android, Kotlin + CameraManager).
/// Увесь код Platform Channels інкапсульований тут, у плагіні.
class MethodChannelMyFlashlightPlugin extends MyFlashlightPluginPlatform {
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel(
    'my_flashlight_plugin',
  );

  Future<bool> _invoke(String method) async {
    try {
      return await methodChannel.invokeMethod<bool>(method) ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'NO_FLASH') {
        throw FlashlightUnavailableException(e.message ?? 'Немає спалаху');
      }
      throw FlashlightException(e.message ?? e.code);
    } on MissingPluginException {
      throw const FlashlightUnsupportedException('ця платформа');
    }
  }

  @override
  Future<bool> toggle() => _invoke('toggle');

  @override
  Future<bool> isAvailable() => _invoke('isAvailable');
}
