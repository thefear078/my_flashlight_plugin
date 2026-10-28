import 'package:flutter/foundation.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin_platform_interface.dart';
import 'package:my_flashlight_plugin/src/exceptions.dart';

export 'src/exceptions.dart';

/// Публічний API плагіна апаратного ліхтарика.
///
/// Нативна логіка реалізована лише для Android. На інших платформах
/// методи не викликають канал, а кидають [FlashlightUnsupportedException],
/// тож застосунок не падає, а може показати повідомлення.
abstract final class MyFlashlightPlugin {
  /// Чи підтримує поточна платформа ліхтарик.
  static bool get isPlatformSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static String get _platformName =>
      kIsWeb ? 'Web' : defaultTargetPlatform.name;

  static void _ensureSupported() {
    if (!isPlatformSupported) {
      throw FlashlightUnsupportedException(_platformName);
    }
  }

  /// Перемикає ліхтарик. Повертає новий стан (`true` — увімкнено).
  ///
  /// Кидає [FlashlightUnsupportedException] (не Android) або
  /// [FlashlightUnavailableException] (немає спалаху).
  static Future<bool> toggle() async {
    _ensureSupported();
    return MyFlashlightPluginPlatform.instance.toggle();
  }

  /// Чи має пристрій спалах (на непідтримуваних платформах — `false`).
  static Future<bool> isAvailable() async {
    if (!isPlatformSupported) return false;
    return MyFlashlightPluginPlatform.instance.isAvailable();
  }
}
