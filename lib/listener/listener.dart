import '../util/util.dart';

typedef ScreenCaptureListener = void Function(ScreenEvent keyEvent);
typedef CancelScreenListening = void Function();


class ScreenEvent {
   late String imgPath;
   late String imgName;

   ScreenEvent(List<String> list) {
      imgPath = list[0];
      imgPath = list[1];
   }
}
