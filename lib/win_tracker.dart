import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:win_tracker/util/util.dart';
import 'listener/listener.dart';
import 'src/captured_data.dart';

class WinTracker{
  WinTracker._() {
    if (Platform.isLinux) {



      // _systemScreenCapturer = SystemScreenCapturerImplLinux();
    } else if (Platform.isMacOS) {
      // _systemScreenCapturer = SystemScreenCapturerImplMacOS();
    } else if (Platform.isWindows) {
      // _systemScreenCapturer = SystemScreenCapturerImplWindows(_channel);
    }
  }
  static bool? isLeter(int vk) {
    if (WinTracker.virtualKeyCode2StringMap != null) {
      var A = WinTracker.virtualKeyString2CodeMap!['A'];
      var Z = WinTracker.virtualKeyString2CodeMap!['Z'];
      if ((vk >= A!) && (vk <= Z!)) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }

  static bool? isNumber(int vk) {
    if (WinTracker.virtualKeyCode2StringMap != null) {
      var key_0 = WinTracker.virtualKeyString2CodeMap!['0'];
      var key_9 = WinTracker.virtualKeyString2CodeMap!['9'];
      if ((vk >= key_0!) && (vk <= key_9!)) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }
  static final WinTracker instance = WinTracker._();
  KeyBoardState state = KeyBoardState();
  static Map<String, int>? virtualKeyString2CodeMap;
  static Map<int, List<String>>? virtualKeyCode2StringMap;
  static const MethodChannel _channel = MethodChannel('win_tracker');
  static const EventChannel _eventKeyboard = EventChannel("win_tracker/keyboard_event");
  static const EventChannel _eventScreen = EventChannel("win_tracker/screen_capture");
  int nextListenerId = 1;
  CancelListening? _cancelListening;
  CancelScreenListening? _cancelScreenListening;
  Future<void> requestAccess({
    bool onlyOpenPrefPane = false,
  }) async {
    if (Platform.isMacOS) {
      final Map<String, dynamic> arguments = {
        'onlyOpenPrefPane': onlyOpenPrefPane,
      };
      await _channel.invokeMethod('requestAccess', arguments);
    }
  }
  static Future<Map<String, int>> get _getVirtualKeyString2CodeMap async {
    final Map<String, int> virtualKeyMap = Map<String, int>.from(
        await _channel.invokeMethod('getVirtualKeyMap', 0));
    return virtualKeyMap;
  }
  Future<bool> isAccessAllowed() async {
    if (!kIsWeb && Platform.isMacOS) {
      return await _channel.invokeMethod('isAccessAllowed');
    }
    return true;
  }

  static Future<void> init() async {
    virtualKeyString2CodeMap = await _getVirtualKeyString2CodeMap;
    virtualKeyCode2StringMap = await _getVirtualKeyCode2StringMap;
  }
  static Future<Map<int, List<String>>> get _getVirtualKeyCode2StringMap async {
    Map<int, List<String>> ret = {};
    final Map<int, List<dynamic>> virtualKeyMap = Map<int, List<dynamic>>.from(
        await _channel.invokeMethod('getVirtualKeyMap', 1));
    virtualKeyMap.forEach((key, value) {
      ret[key] = List<String>.from(value);
    });
    return ret;
  }

  Future<dynamic> screenCapture(AutoScreenCapture options) async {
    var optionMap = <String, String?>{};
    optionMap.putIfAbsent("img_path", () => options.imgPath);
    optionMap.putIfAbsent("intervel", () => options.intervel);

    return await _channel.invokeMethod('screenCapture');
  }

  Future<dynamic> startkeyboardEventCapture(AutoScreenCapture options) async {
    var optionMap = <String, String?>{};
    optionMap.putIfAbsent("img_path", () => options.imgPath);
    optionMap.putIfAbsent("intervel", () => options.intervel);
    return await _channel.invokeMethod('keyboardEventCapture');
  }
  Future<dynamic> appAndUrlTracking() async {
    return await _channel.invokeMethod('appAndUrlTracking');
  }


  startListening(Listener listener) async {
    var subscription =
    _eventKeyboard.receiveBroadcastStream(nextListenerId++).listen(//listener
            (dynamic msg) {
          var list = List<int>.from(msg);
          var keyEvent = KeyEvent(list);
          if (keyEvent.isKeyDown) {
            if (!state.state.contains(keyEvent.vkCode)) {
              state.state.add(keyEvent.vkCode);
            }
          } else {
            if (state.state.contains(keyEvent.vkCode)) {
              state.state.remove(keyEvent.vkCode);
            }
          }
          listener(keyEvent);
        }, cancelOnError: true);
    debugPrint("keyboard_event/event startListening");
    _cancelListening = () {
      subscription.cancel();
      debugPrint("keyboard_event/event canceled");
    };
  }

  startScreenListening(ScreenCaptureListener listener) async {
    var subscription =
    _eventScreen.receiveBroadcastStream(nextListenerId++).listen(//listener
            (dynamic msg) {
          var list = List<String>.from(msg);
          var screenEvent = ScreenEvent(list);
          listener(screenEvent);
        }, cancelOnError: true);
    _cancelScreenListening = () {
      subscription.cancel();
      debugPrint("win_tracker/screen_capture/event canceled");
    };
  }

  cancelScreenListening() async {
    if (_cancelListening != null) {
      _cancelListening!();
      _cancelListening = null;
    } else {
      debugPrint("win_tracker/screen_capture/event No Need");
    }
    if (_cancelScreenListening != null) {
      _cancelScreenListening!();
      _cancelScreenListening = null;
    } else {
      debugPrint("win_tracker/screen_capture/event No Need");
    }
  }
}
KeyEventMsg toKeyEventMsg(int v) {
  KeyEventMsg keyMsg;
  switch (v) {
    case 0:
      keyMsg = KeyEventMsg.WM_KEYDOWN;
      break;
    case 1:
      keyMsg = KeyEventMsg.WM_KEYUP;
      break;
    case 2:
      keyMsg = KeyEventMsg.WM_SYSKEYDOWN;
      break;
    case 3:
      keyMsg = KeyEventMsg.WM_SYSKEYDOWN;
      break;
    default:
      keyMsg = KeyEventMsg.WM_UNKNOW;
      break;
  }
  return keyMsg;
}
typedef Listener = void Function(KeyEvent keyEvent);
typedef CancelListening = void Function();
class KeyEvent {
  late KeyEventMsg keyMsg;
  late int vkCode;
  late int scanCode;
  late int flags;
  late int time;
  late int dwExtraInfo;

  KeyEvent(List<int> list) {
    keyMsg = toKeyEventMsg(list[0]);
    vkCode = list[1];
    scanCode = list[2];
    flags = list[3];
    time = list[4];
    dwExtraInfo = list[5];
  }

  bool get isKeyUP =>
      (keyMsg == KeyEventMsg.WM_KEYUP) || (keyMsg == KeyEventMsg.WM_SYSKEYUP);
  bool get isKeyDown => !isKeyUP;
  bool get isSysKey =>
      (keyMsg == KeyEventMsg.WM_SYSKEYUP) ||
          (keyMsg == KeyEventMsg.WM_SYSKEYDOWN);

  String? get vkName => WinTracker.virtualKeyCode2StringMap?[vkCode]?[0];

  bool? get isLeter => WinTracker.isLeter(vkCode);
  bool? get isNumber => WinTracker.isNumber(vkCode);

  @override
  String toString() {
    var sb = StringBuffer();
    var map = WinTracker.virtualKeyCode2StringMap;
    String? name;
    if (map != null) {
      name = map[vkCode]?[0];
    }
    name ??= '<Unknow Key $vkCode>';
    sb.write('KeyEvent ${isKeyUP ? "↑" : "↓"}$name');
    return sb.toString();
  }
}
class KeyBoardState {
  Set<int> state = <int>{};
  KeyBoardState();
  @override
  String toString() {
    if (WinTracker.virtualKeyCode2StringMap != null) {
      var sb = StringBuffer();
      bool isFirst = true;
      sb.write('[');
      for (var key in state) {
        if (isFirst) {
          isFirst = false;
        } else {
          sb.write(',');
        }
        var str = WinTracker.virtualKeyCode2StringMap![key]?[0];
        sb.write(str ?? key.toString());
      }
      sb.write(']');
      return sb.toString();
    } else {
      return state.toString();
    }
  }
}
