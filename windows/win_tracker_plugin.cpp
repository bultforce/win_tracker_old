#include "include/win_tracker/win_tracker_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>
#include <string>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <atlimage.h>
#include <codecvt>
#include <fstream>
#include <map>
#include <memory>
#include <sstream>


using namespace Gdiplus;
using namespace std;
using namespace flutter;
namespace {

int GetEncoderClsid(const WCHAR* format, CLSID* pClsid)
{
	UINT num = 0;
	UINT size = 0;

	ImageCodecInfo* pImage = NULL;

	GetImageEncodersSize(&num, &size);
	if (size == 0) return -1;

	pImage = (ImageCodecInfo*)(malloc(size));
	if (pImage == NULL) return -1;

	GetImageEncoders(num, size, pImage);

	for (UINT j = 0; j < num; ++j)
	{
		if (wcscmp(pImage[j].MimeType, format) == 0)
		{
			*pClsid = pImage[j].Clsid;
			free(pImage);
			return j;
		}
	}
	free(pImage);
	return -1;
}
class WinTrackerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WinTrackerPlugin();

  virtual ~WinTrackerPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
    void WinTrackerPlugin::SaveClipboardImageAsPngFile(
        const flutter::MethodCall<flutter::EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void WinTrackerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "win_tracker",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<WinTrackerPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

WinTrackerPlugin::WinTrackerPlugin() {}

WinTrackerPlugin::~WinTrackerPlugin() {}

void WinTrackerPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("screenCapture") == 0) {
  string strMytestString("metthod getted");
      cout << strMytestString;
       SaveClipboardImageAsPngFile(method_call, std::move(result));

  } else {
    result->NotImplemented();
  }
}

}  // namespace

void WinTrackerPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  WinTrackerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
void WinTrackerPlugin::SaveClipboardImageAsPngFile(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    const flutter::EncodableMap &args = std::get<flutter::EncodableMap>(*method_call.arguments());

    std::string imagePath = std::get<std::string>(args.at(flutter::EncodableValue("img_path")));
    ULONG_PTR gdiplustoken;
    GdiplusStartupInput gdistartupinput;
	GdiplusStartupOutput gdistartupoutput;
    gdistartupinput.SuppressBackgroundThread = true;
    GdiplusStartup(& gdiplustoken,& gdistartupinput,& gdistartupoutput); //start GDI+

	HDC dc=GetDC(GetDesktopWindow());//get desktop content
	HDC dc2 = CreateCompatibleDC(dc);
    RECT rc0kno;  // rectangle  Object //copy context
	GetClientRect(GetDesktopWindow(),&rc0kno);// get desktop size;
	int w = rc0kno.right-rc0kno.left;//width
	int h = rc0kno.bottom-rc0kno.top;//height

    HBITMAP hbitmap = CreateCompatibleBitmap(dc,w,h);  //create bitmap
	HBITMAP holdbitmap = (HBITMAP) SelectObject(dc2,hbitmap);

	BitBlt(dc2, 0, 0, w, h, dc, 0, 0, SRCCOPY);  //copy pixel from pulpit to bitmap

	CLSID encoderID;

	GetEncoderClsid(L"image/png", &encoderID);//image/jpeg

    Bitmap* bm= new Bitmap(hbitmap,NULL);
	bm->Save(L"C:\\Users\\sagar\\Documents\\image.png",& encoderID);   //save in jpeg format
	SelectObject(dc2,holdbitmap);  //Release Objects
	DeleteObject(dc2);
	DeleteObject(hbitmap);

	ReleaseDC(GetDesktopWindow(),dc);
	GdiplusShutdown(gdiplustoken);

    result->Success(flutter::EncodableValue("resultMap--3"));
}
