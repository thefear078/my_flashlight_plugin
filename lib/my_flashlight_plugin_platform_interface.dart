import 'package:my_flashlight_plugin/my_flashlight_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Платформний інтерфейс плагіна (можна підмінити в тестах).
abstract class MyFlashlightPluginPlatform extends PlatformInterface {
  MyFlashlightPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static MyFlashlightPluginPlatform _instance =
      MethodChannelMyFlashlightPlugin();

  static MyFlashlightPluginPlatform get instance => _instance;

  static set instance(MyFlashlightPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Перемикає ліхтарик; повертає новий стан (`true` — увімкнено).
  Future<bool> toggle() => throw UnimplementedError('toggle()');

  /// Чи має пристрій спалах.
  Future<bool> isAvailable() => throw UnimplementedError('isAvailable()');
}
