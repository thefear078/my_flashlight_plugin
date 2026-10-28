/// Базова помилка плагіна ліхтарика.
class FlashlightException implements Exception {
  const FlashlightException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Платформа не підтримується (iOS, Web, desktop).
class FlashlightUnsupportedException extends FlashlightException {
  const FlashlightUnsupportedException(String platform)
    : super('Ліхтарик не підтримується на платформі: $platform');
}

/// Пристрій не має спалаху (планшет, емулятор).
class FlashlightUnavailableException extends FlashlightException {
  const FlashlightUnavailableException(super.message);
}
