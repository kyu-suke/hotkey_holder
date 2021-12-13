import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:magnetica/magnetica.dart';

typedef HotKeyHolderKeyCharacter = KeyCharacter;
typedef HotKeyHolderModifier = Modifier;
class HotKeyHolderKeyCombo extends KeyCombo {
  final KeyCharacter key;
  final Modifiers modifiers;
  HotKeyHolderKeyCombo({required this.key, this.modifiers = const []}):super(key: key, modifiers: modifiers);
}

class HotKeyHolder extends StatefulWidget {
  const HotKeyHolder(
      {Key? key,
      required this.hotKeyName,
      required this.onInput,
      required this.onDelete,
      required this.event,
      this.keyCombo})
      : super(key: key);

  final String hotKeyName;
  final Function event;
  final void Function(HotKeyHolderKeyCombo) onInput;
  final Function onDelete;
  final HotKeyHolderKeyCombo? keyCombo;

  @override
  _HotKeyHolderState createState() => _HotKeyHolderState();
}

class _HotKeyHolderState extends State<HotKeyHolder> {
  static const EventChannel eventChannel = EventChannel('hotkey_holder');

  final FocusNode _focus = FocusNode();
  String _keyChar = "";
  StreamSubscription<dynamic>? _streamSubscription;

  Color _color = Colors.grey;
  double _width = 1;

  TextStyle _ctrlTextStyle = const TextStyle(color: Colors.grey);
  TextStyle _optionTextStyle = const TextStyle(color: Colors.grey);
  TextStyle _shiftTextStyle = const TextStyle(color: Colors.grey);
  TextStyle _cmdTextStyle = const TextStyle(color: Colors.grey);

  void _initTextStyle() {
    _ctrlTextStyle = const TextStyle(color: Colors.grey);
    _optionTextStyle = const TextStyle(color: Colors.grey);
    _shiftTextStyle = const TextStyle(color: Colors.grey);
    _cmdTextStyle = const TextStyle(color: Colors.grey);
  }

  void _coloringTextStyle(Modifiers modifiers) {
    if (modifiers.contains(Modifier.control)) {
      _ctrlTextStyle = const TextStyle(color: Colors.lightBlue);
    }
    if (modifiers.contains(Modifier.option)) {
      _optionTextStyle = const TextStyle(color: Colors.lightBlue);
    }
    if (modifiers.contains(Modifier.shift)) {
      _shiftTextStyle = const TextStyle(color: Colors.lightBlue);
    }
    if (modifiers.contains(Modifier.command)) {
      _cmdTextStyle = const TextStyle(color: Colors.lightBlue);
    }
  }

  @override
  void initState() {
    super.initState();

    _focus.addListener(_onFocusChange);
    Magnetica.createStream();

    if (widget.keyCombo != null) {
      _registerHotKey(widget.keyCombo!);
    }
  }

  void _onFocusChange() {
    setState(() {
      if (_focus.hasFocus) {
        _streamSubscription = eventChannel
            .receiveBroadcastStream()
            .listen(_onEvent, onError: _onError);
        _color = Colors.blue;
        _width = 1.5;
      } else {
        _streamSubscription!.cancel();
        _color = Colors.grey;
        _width = 1;
      }
    });
  }

  void _registerHotKey(KeyCombo keyCombo) {
    setState(() {
      _initTextStyle();
      _coloringTextStyle(keyCombo.modifiers);

      _keyChar = keyCombo.key.encode();
      Magnetica.register(
          keyCombo: keyCombo,
          hotKeyName: widget.hotKeyName,
          hotKeyFunction: widget.event);
    });
  }

  void _onEvent(Object? event) {
    if (event == null) {
      return;
    }
    final map = event as Map;
    final char = map["character"] ?? "";

    final modifiers = map["modifiers"].cast<String?>() as List<String?>;
    final mods =
        modifiers.map((String? e) => ModifierExtension.fromString(e!)).toList();
    setState(() {
      _initTextStyle();
      _coloringTextStyle(mods);

      final modifiers = map["modifiers"].cast<String?>() as List<String?>;
      if (modifiers.isEmpty || map["character"] == "") {
        return;
      }

      _keyChar = char;
      final keyCombo =HotKeyHolderKeyCombo(
          key: KeyCharacterExtension.fromString(map["character"]),
          modifiers: modifiers
              .map((String? e) => ModifierExtension.fromString(e!))
              .toList()) ;
      Magnetica.register(
          keyCombo: keyCombo,
          hotKeyName: widget.hotKeyName,
          hotKeyFunction: widget.event);

      FocusManager.instance.primaryFocus?.unfocus();
      widget.onInput(keyCombo);
    });
  }

  void unregister() {
    setState(() {
      _initTextStyle();
      _keyChar = "";
      Magnetica.unregister(hotKeyName: widget.hotKeyName);
      widget.onDelete();
    });
  }

  void _onError(Object error) {
    throw error;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 40,
        child: GestureDetector(
          onTap: () {
            _focus.requestFocus();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            padding: const EdgeInsets.all(5.0),
            width: 200,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: _color, width: _width),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Row(children: [
                  Text(
                    " ⌘ ",
                    style: _cmdTextStyle,
                  ),
                  Text(
                    " ⇧ ",
                    style: _shiftTextStyle,
                  ),
                  Text(
                    " ⌥ ",
                    style: _optionTextStyle,
                  ),
                  Text(
                    " ⌃ ",
                    style: _ctrlTextStyle,
                  ),
                ]),
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    focusNode: _focus,
                    readOnly: true,
                    controller: TextEditingController(text: _keyChar),
                    style: const TextStyle(height: 30, color: Colors.lightBlue),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const SizedBox(width: 10),
                Transform.rotate(
                  angle: 45 * math.pi / 180,
                  child: IconButton(
                    splashRadius: 10,
                    iconSize: 15,
                    onPressed: () => {unregister()},
                    icon: const Icon(Icons.add_circle_outline_outlined,
                        color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
