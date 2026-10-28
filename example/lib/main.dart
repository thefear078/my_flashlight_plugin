import 'package:flutter/material.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin.dart';

void main() => runApp(const MaterialApp(home: FlashlightDemo()));

class FlashlightDemo extends StatelessWidget {
  const FlashlightDemo({super.key});

  Future<void> _toggle(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final on = await MyFlashlightPlugin.toggle();
      messenger.showSnackBar(
        SnackBar(content: Text(on ? 'Увімкнено' : 'Вимкнено')),
      );
    } on FlashlightException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('my_flashlight_plugin')),
    body: Center(
      child: FilledButton.icon(
        onPressed: () => _toggle(context),
        icon: const Icon(Icons.flashlight_on),
        label: const Text('Перемкнути ліхтарик'),
      ),
    ),
  );
}
