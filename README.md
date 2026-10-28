# my_flashlight_plugin

Flutter-плагін керування апаратним ліхтариком (лаб. №7, «Розроблення
мобільних додатків»). Автор: Ягусевич Костянтин, КБ-408.

- **Android:** Kotlin, `CameraManager.setTorchMode` (Android 6.0+).
  Перед викликом перевіряється `FEATURE_CAMERA_FLASH` і
  `FLASH_INFO_AVAILABLE` — на пристроях без спалаху повертається помилка
  `NO_FLASH`, а не виняток.
- **iOS / Web / desktop:** канал не викликається; кидається
  `FlashlightUnsupportedException` (graceful degradation).
- Увесь код `MethodChannel` — всередині плагіна.

## API
```dart
import 'package:my_flashlight_plugin/my_flashlight_plugin.dart';

try {
  final isOn = await MyFlashlightPlugin.toggle();
} on FlashlightUnsupportedException catch (e) {
  // не Android
} on FlashlightUnavailableException catch (e) {
  // немає спалаху
}
final supported = MyFlashlightPlugin.isPlatformSupported;
final hasFlash = await MyFlashlightPlugin.isAvailable();
```

## Підключення
```yaml
dependencies:
  my_flashlight_plugin:
    git:
      url: https://github.com/thefear078/my_flashlight_plugin.git
```
