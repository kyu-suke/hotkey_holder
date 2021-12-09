import 'package:flutter/material.dart';
import 'package:hotkey_holder/hotkey_holder.dart';
import 'package:magnetica/magnetica.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("shortcut type A"),
              HotKeyHolder(
                  hotKeyName: "shortcutA",
                  event: () {
                    print("this is shortcut A");
                  }),
              const SizedBox(height: 20),
              const Text("shortcut type B"),
              HotKeyHolder(
                  hotKeyName: "shortcutB",
                  event: () {
                    print("this is shortcut B");
                  },
                  keyCombo: KeyCombo(
                      key: KeyCharacter.b, modifiers: [Modifier.command])),
            ],
          ),
        ),
      ),
    );
  }
}
