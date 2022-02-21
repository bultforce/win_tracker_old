import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:win_tracker/win_tracker.dart';

void main() {
  const MethodChannel channel = MethodChannel('win_tracker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await WinTracker.platformVersion, '42');
  });
}
