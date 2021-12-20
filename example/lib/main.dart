import 'package:flutter/material.dart';
import 'package:hotkey_holder/hotkey_holder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HotKeyHolderKeyCombo? _keyCombo;

  @override
  void initState() {
    super.initState();
    setState(() {
      _keyCombo = HotKeyHolderKeyCombo(
          key: HotKeyHolderKeyCharacter.q,
          modifiers: [HotKeyHolderModifier.control]);
    });
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
                  onInput: (keyCombo) {
                    print("shortcut A's keyCombo is input");
                    print(keyCombo.modifiers);
                    print(keyCombo.key);
                  },
                  onDelete: () {
                    print("shortcut A is deleted");
                  },
                  event: () {
                    print("this is shortcut A");
                  }),
              const SizedBox(height: 20),
              const Text("shortcut type B"),
              HotKeyHolder(
                  hotKeyName: "shortcutB",
                  onInput: (keyCombo) {
                    print("shortcut B's keyCombo is input");
                  },
                  onDelete: () {
                    print("shortcut B is deleted");
                  },
                  event: () {
                    print("this is shortcut B");
                  },
                  keyCombo: HotKeyHolderKeyCombo(
                      key: HotKeyHolderKeyCharacter.b,
                      modifiers: [HotKeyHolderModifier.command])),
              const SizedBox(height: 20),
              const Text("shortcut type C"),
              HotKeyHolder(
                  hotKeyName: "shortcutC",
                  onInput: (keyCombo) {
                    print("shortcut C's keyCombo is input");
                  },
                  onDelete: () {
                    print("shortcut C is deleted");
                  },
                  event: () {
                    print("this is shortcut C");
                  },
                  keyCombo: _keyCombo),
            ],
          ),
        ),
      ),
    );
  }
}
