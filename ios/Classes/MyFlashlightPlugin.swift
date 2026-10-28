import Flutter
import UIKit

/// iOS-реалізація не передбачена завданням: Dart-частина плагіна
/// не викликає канал на iOS, а повертає FlashlightUnsupportedException.
public class MyFlashlightPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "my_flashlight_plugin", binaryMessenger: registrar.messenger())
    let instance = MyFlashlightPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterError(code: "UNSUPPORTED_PLATFORM",
                        message: "Ліхтарик підтримується лише на Android",
                        details: nil))
  }
}
