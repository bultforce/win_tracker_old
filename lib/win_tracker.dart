import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static final WinTracker instance = WinTracker._();
  final MethodChannel _channel = const MethodChannel('win_tracker');
  static const EventChannel _eventKeyboard = EventChannel("win_tracker/keyboard_event");
  static const EventChannel _eventScreen = EventChannel("win_tracker/screen_capture");
  int nextListenerId = 1;
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

  Future<bool> isAccessAllowed() async {
    if (!kIsWeb && Platform.isMacOS) {
      return await _channel.invokeMethod('isAccessAllowed');
    }
    return true;
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
    if (_cancelScreenListening != null) {
      _cancelScreenListening!();
      _cancelScreenListening = null;
    } else {
      debugPrint("win_tracker/screen_capture/event No Need");
    }
  }
}
