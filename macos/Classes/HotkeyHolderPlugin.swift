import Cocoa
import FlutterMacOS
import Carbon
import Magnet

var flutterEventSink: FlutterEventSink?

public class HotkeyHolderPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterEventChannel(name: "hotkey_holder",
                                          binaryMessenger: registrar.messenger)
        let instance = HotkeyHolderPlugin()
        
        channel.setStreamHandler(instance)
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            let nsEvent = $0
            guard let eventSink = flutterEventSink else {
                return nsEvent
            }
            
            let modifierFlag = nsEvent.keyCombo?.keyEquivalentModifierMask
            var modifiers: [String] = []
            if modifierFlag != nil {
                if modifierFlag!.contains(.shift) {
                    modifiers.append("shift")
                }
                if modifierFlag!.contains(.control) {
                    modifiers.append("control")
                    
                }
                if modifierFlag!.contains(.option) {
                    modifiers.append("option")
                    
                }
                if modifierFlag!.contains(.command) {
                    modifiers.append("command")
                }
            }

            eventSink([
                "character":nsEvent.keyCombo?.convertCharacter ?? "",
                "modifiers":modifiers,
            ])
            return nsEvent
        }
        
    }
    
    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        flutterEventSink = eventSink
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        flutterEventSink = nil
        return nil
    }
    
}

public extension FlutterViewController {
    
    override func flagsChanged(with theEvent: NSEvent) {
        
        guard let eventSink = flutterEventSink else {
            return
        }
        
        eventSink(decideMod(modifierFlag: NSEvent.ModifierFlags(carbonModifiers: theEvent.modifierFlags.carbonModifiers())))
        super.flagsChanged(with: theEvent)
    }
    
    func decideMod(modifierFlag: NSEvent.ModifierFlags) -> [String:Any] {
        var modifiers: [String] = []
        if modifierFlag.contains(.shift) {
            modifiers.append("shift")
        }
        if modifierFlag.contains(.control) {
            modifiers.append("control")
            
        }
        if modifierFlag.contains(.option) {
            modifiers.append("option")
            
        }
        if modifierFlag.contains(.command) {
            modifiers.append("command")
        }
        
        return [
            "character":"",
            "modifiers":modifiers,
        ]
    }
}


public extension KeyCombo {
    var convertCharacter: String {
        get {
            switch self.QWERTYKeyCode {
            case kVK_ANSI_A:
                return "a"
            case kVK_ANSI_S:
                return "s"
            case kVK_ANSI_D:
                return "d"
            case kVK_ANSI_F:
                return "f"
            case kVK_ANSI_H:
                return "h"
            case kVK_ANSI_G:
                return "g"
            case kVK_ANSI_Z:
                return "z"
            case kVK_ANSI_X:
                return "x"
            case kVK_ANSI_C:
                return "c"
            case kVK_ANSI_V:
                return "v"
            case kVK_ANSI_B:
                return "b"
            case kVK_ANSI_Q:
                return "q"
            case kVK_ANSI_W:
                return "w"
            case kVK_ANSI_E:
                return "e"
            case kVK_ANSI_R:
                return "r"
            case kVK_ANSI_Y:
                return "y"
            case kVK_ANSI_T:
                return "t"
            case kVK_ANSI_1:
                return "1"
            case kVK_ANSI_2:
                return "2"
            case kVK_ANSI_3:
                return "3"
            case kVK_ANSI_4:
                return "4"
            case kVK_ANSI_6:
                return "6"
            case kVK_ANSI_5:
                return "5"
            case kVK_ANSI_Equal:
                return "="
            case kVK_ANSI_9:
                return "9"
            case kVK_ANSI_7:
                return "7"
            case kVK_ANSI_Minus:
                return "-"
            case kVK_ANSI_8:
                return "8"
            case kVK_ANSI_0:
                return "0"
            case kVK_ANSI_RightBracket:
                return "RightBracket"
            case kVK_ANSI_O:
                return "o"
            case kVK_ANSI_U:
                return "u"
            case kVK_ANSI_LeftBracket:
                return "LeftBracket"
            case kVK_ANSI_I:
                return "i"
            case kVK_ANSI_P:
                return "p"
            case kVK_ANSI_L:
                return "l"
            case kVK_ANSI_J:
                return "j"
            case kVK_ANSI_Quote:
                return "'"
            case kVK_ANSI_K:
                return "k"
            case kVK_ANSI_Semicolon:
                return ";"
            case kVK_ANSI_Backslash:
                return "\\"
            case kVK_ANSI_Comma:
                return ","
            case kVK_ANSI_Slash:
                return "/"
            case kVK_ANSI_N:
                return "n"
            case kVK_ANSI_M:
                return "m"
            case kVK_ANSI_Period:
                return "."
            case kVK_ANSI_Grave:
                return "`"
            case kVK_Function:
                return "fn"
            case kVK_F17:
                return "F17"
            case kVK_F18:
                return "F18"
            case kVK_F19:
                return "F19"
            case kVK_F20:
                return "F20"
            case kVK_F5:
                return "F5"
            case kVK_F6:
                return "F6"
            case kVK_F7:
                return "F7"
            case kVK_F3:
                return "F3"
            case kVK_F8:
                return "F8"
            case kVK_F9:
                return "F9"
            case kVK_F11:
                return "F11"
            case kVK_F13:
                return "F13"
            case kVK_F16:
                return "F16"
            case kVK_F14:
                return "F14"
            case kVK_F10:
                return "F10"
            case kVK_F12:
                return "F12"
            case kVK_F15:
                return "F15"
            case kVK_Help:
                return "Help"
            case kVK_Home:
                return "Home"
            case kVK_PageUp:
                return "PageUp"
            case kVK_ForwardDelete:
                return "ForwardDelete"
            case kVK_F4:
                return "F4"
            case kVK_End:
                return "End"
            case kVK_F2:
                return "F2"
            case kVK_PageDown:
                return "PageDown"
            case kVK_F1:
                return "F1"
            case kVK_LeftArrow:
                return "←"
            case kVK_RightArrow:
                return "→"
            case kVK_DownArrow:
                return "↓"
            case kVK_UpArrow:
                return "↑"
            case kVK_JIS_Yen:
                return "¥"
            case kVK_JIS_Underscore:
                return "_"
            case kVK_JIS_Eisu:
                return "eisu"
            case kVK_JIS_Kana:
                return "kana"
            case kVK_Return:
                return "enter"
            case kVK_Tab:
                return "tab"
            case kVK_Space:
                return "space"
            case kVK_Delete:
                return "delete"
            case kVK_Escape:
                return "esc"
            case kVK_Command:
                return "command"
            case kVK_Shift:
                return "shift"
            case kVK_CapsLock:
                return "caps"
            case kVK_Option:
                return "option"
            case kVK_Control:
                return "ctrl"
            case kVK_RightCommand:
                return "rightCommand"
            case kVK_RightShift:
                return "rightShift"
            case kVK_RightOption:
                return "rightOption"
            case kVK_RightControl:
                return "rightCtrl"
            case kVK_F17:
                return "f17"
            case kVK_VolumeUp:
                return "volumeUp"
            case kVK_VolumeDown:
                return "volumeDown"
            case kVK_Mute:
                return "mute"
            default:
                return ""
            }
        }
    }
}

