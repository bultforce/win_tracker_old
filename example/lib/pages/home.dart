import 'dart:io';
import 'package:flutter/material.dart';
import 'package:preference_list/preference_list.dart';
import 'package:win_tracker/win_tracker.dart';
import 'package:win_tracker/src/captured_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAccessAllowed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _isAccessAllowed = await WinTracker.instance.isAccessAllowed();
    WinTracker.init();
    setState(() {});
  }

  void _handleClickCapture() async {
    // Directory directory = await getApplicationDocumentsDirectory();
    // String imageName =
    //     'Screenshot-${DateTime.now().millisecondsSinceEpoch}.png';
    // String imagePath =
    //     '${directory.path}/screen_capturer_example/Screenshots/$imageName';
    // _lastCapturedData = await ScreenCapturer.instance.capture(
    //   imagePath: imagePath,
    //   silent: true,
    // );
    // if (_lastCapturedData != null) {
    //   // ignore: avoid_print
    //   print(_lastCapturedData!.toJson());
    // } else {
    //   // ignore: avoid_print
    //   print('User canceled capture');
    // }
    print("checking click");
    WinTracker.instance.screenCapture(AutoScreenCapture(imgPath: "bhjbjhbhj", intervel: "3"));
  }

  void _startKeyboardEvent() async {
    print("on click keyboard start listener");
    if(Platform.isWindows){
      WinTracker.instance.startListening((keyEvent) {
        print(keyEvent);
      });
    }else{
      WinTracker.instance.startkeyboardEventCapture(AutoScreenCapture(imgPath: "bhjbjhbhj", intervel: "3"));
    }
  }

  void _stopKeyboardEvent() async {
    print("on click keyboard stop listener");
    if(Platform.isWindows){
      WinTracker.instance.cancelScreenListening();
    }else{
      WinTracker.instance.cancelScreenListening();
    }

  }

  void _appAndUrlTracking() async {
    print("on click appAndUrlTracking");
    if(Platform.isWindows){
      WinTracker.instance.appAndUrlTracking().then((value) {
        print(value);
      });
    }else{
      WinTracker.instance.cancelScreenListening();
    }

  }

  void _brawserAndUrlTracking() async {
    print("on click _brawserAndUrlTracking");
    if(Platform.isWindows){
      WinTracker.instance.brawserAndUrlTracking().then((value) {
        print(value);
      });
    }else{
      WinTracker.instance.cancelScreenListening();
    }

  }



  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: <Widget>[
        if (Platform.isMacOS)
          PreferenceListSection(
            children: [
              PreferenceListItem(
                title: const Text('isAccessAllowed'),
                accessoryView: Text('$_isAccessAllowed'),
                onTap: () async {
                  bool allowed =
                      await WinTracker.instance.isAccessAllowed();

                  setState(() {
                    _isAccessAllowed = allowed;
                  });
                },
              ),
              PreferenceListItem(
                title: const Text('requestAccess'),
                onTap: () async {
                  await WinTracker.instance.requestAccess();
                },
              ),
            ],
          ),
        PreferenceListSection(
          title: const Text('METHODS'),
          children: [
            PreferenceListItem(
              title: const Text('onClickScreenCapture'),
              onTap: () {
                _handleClickCapture();
              },
            ),
            PreferenceListItem(
              title: const Text('startkeyboardEvent'),
              onTap: () {
                _startKeyboardEvent();
              },
            ),
            PreferenceListItem(
              title: const Text('stopkeyboardEvent'),
              onTap: () {
                _stopKeyboardEvent();
              },
            ),
            PreferenceListItem(
              title: const Text('app tracking'),
              onTap: () {
                Future.delayed(Duration(seconds: 5), (){
                  _appAndUrlTracking();
                });
              },
            ),
          ],
        ),
        PreferenceListItem(
          title: const Text('brawser and url tracking'),
          onTap: () {
            Future.delayed(Duration(seconds: 5), (){
              _brawserAndUrlTracking();
            });

          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _buildBody(context),
    );
  }
}
