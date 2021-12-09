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
            var character = ""
            switch self.QWERTYKeyCode {
            case kVK_ANSI_A:
                character = "a"
            case kVK_ANSI_S:
                character = "s"
            case kVK_ANSI_D:
                character = "d"
            case kVK_ANSI_F:
                character = "f"
            case kVK_ANSI_H:
                character = "h"
            case kVK_ANSI_G:
                character = "g"
            case kVK_ANSI_Z:
                character = "z"
            case kVK_ANSI_X:
                character = "x"
            case kVK_ANSI_C:
                character = "c"
            case kVK_ANSI_V:
                character = "v"
            case kVK_ANSI_B:
                character = "b"
            case kVK_ANSI_Q:
                character = "q"
            case kVK_ANSI_W:
                character = "w"
            case kVK_ANSI_E:
                character = "e"
            case kVK_ANSI_R:
                character = "r"
            case kVK_ANSI_Y:
                character = "y"
            case kVK_ANSI_T:
                character = "t"
            case kVK_ANSI_1:
                character = "1"
            case kVK_ANSI_2:
                character = "2"
            case kVK_ANSI_3:
                character = "3"
            case kVK_ANSI_4:
                character = "4"
            case kVK_ANSI_6:
                character = "6"
            case kVK_ANSI_5:
                character = "5"
            case kVK_ANSI_Equal:
                character = "="
            case kVK_ANSI_9:
                character = "9"
            case kVK_ANSI_7:
                character = "7"
            case kVK_ANSI_Minus:
                character = "-"
            case kVK_ANSI_8:
                character = "8"
            case kVK_ANSI_0:
                character = "0"
            case kVK_ANSI_RightBracket:
                character = "RightBracket"
            case kVK_ANSI_O:
                character = "O"
            case kVK_ANSI_U:
                character = "U"
            case kVK_ANSI_LeftBracket:
                character = "LeftBracket"
            case kVK_ANSI_I:
                character = "i"
            case kVK_ANSI_P:
                character = "p"
            case kVK_ANSI_L:
                character = "l"
            case kVK_ANSI_J:
                character = "j"
            case kVK_ANSI_Quote:
                character = "'"
            case kVK_ANSI_K:
                character = "k"
            case kVK_ANSI_Semicolon:
                character = ";"
            case kVK_ANSI_Backslash:
                character = "\\"
            case kVK_ANSI_Comma:
                character = ","
            case kVK_ANSI_Slash:
                character = "/"
            case kVK_ANSI_N:
                character = "n"
            case kVK_ANSI_M:
                character = "m"
            case kVK_ANSI_Period:
                character = "."
            case kVK_ANSI_Grave:
                character = "`"
            case kVK_Return:
                character = "⏎"
            case kVK_Tab:
                character = "⇔"
            case kVK_Space:
                character = "☐"
            case kVK_Delete:
                character = "⌫"
            case kVK_Escape:
                character = "Esc"
            case kVK_Command:
                character = "⌘"
            case kVK_Shift:
                character = "⇧"
            case kVK_Option:
                character = "⌥"
            case kVK_Control:
                character = "⌃"
            case kVK_RightCommand:
                character = "⌘"
            case kVK_RightShift:
                character = "⇧"
            case kVK_RightOption:
                character = "⌥"
            case kVK_RightControl:
                character = "⌃"
            case kVK_Function:
                character = "fn"
            case kVK_F17:
                character = "F17"
            case kVK_F18:
                character = "F18"
            case kVK_F19:
                character = "F19"
            case kVK_F20:
                character = "F20"
            case kVK_F5:
                character = "F5"
            case kVK_F6:
                character = "F6"
            case kVK_F7:
                character = "F7"
            case kVK_F3:
                character = "F3"
            case kVK_F8:
                character = "F8"
            case kVK_F9:
                character = "F9"
            case kVK_F11:
                character = "F11"
            case kVK_F13:
                character = "F13"
            case kVK_F16:
                character = "F16"
            case kVK_F14:
                character = "F14"
            case kVK_F10:
                character = "F10"
            case kVK_F12:
                character = "F12"
            case kVK_F15:
                character = "F15"
            case kVK_Help:
                character = "Help"
            case kVK_Home:
                character = "Home"
            case kVK_PageUp:
                character = "PageUp"
            case kVK_ForwardDelete:
                character = "ForwardDelete"
            case kVK_F4:
                character = "F4"
            case kVK_End:
                character = "End"
            case kVK_F2:
                character = "F2"
            case kVK_PageDown:
                character = "PageDown"
            case kVK_F1:
                character = "F1"
            case kVK_LeftArrow:
                character = "←"
            case kVK_RightArrow:
                character = "→"
            case kVK_DownArrow:
                character = "↓"
            case kVK_UpArrow:
                character = "↑"
            case kVK_JIS_Yen:
                character = "¥"
            case kVK_JIS_Underscore:
                character = "_"
            case kVK_JIS_Eisu:
                character = "英数"
            case kVK_JIS_Kana:
                character = "かな"
                
            default:
                character = ""
            }
            return character
        }
    }
}

