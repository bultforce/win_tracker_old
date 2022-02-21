import 'dart:io';
import 'dart:typed_data';
// import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
// class _MyHomePageState extends State<MyHomePage> {
//   Future<Directory?>? _tempDirectory;
//   Future<Directory?>? _appSupportDirectory;
//   Future<Directory?>? _appLibraryDirectory;
//   Future<Directory?>? _appDocumentsDirectory;
//   Future<Directory?>? _externalDocumentsDirectory;
//   Future<List<Directory>?>? _externalStorageDirectories;
//   Future<List<Directory>?>? _externalCacheDirectories;
//
//   void _requestTempDirectory() {
//     setState(() {
//       _tempDirectory = getTemporaryDirectory();
//     });
//   }
//
//   Widget _buildDirectory(
//       BuildContext context, AsyncSnapshot<Directory?> snapshot) {
//     Text text = const Text('');
//     if (snapshot.connectionState == ConnectionState.done) {
//       if (snapshot.hasError) {
//         text = Text('Error: ${snapshot.error}');
//       } else if (snapshot.hasData) {
//         text = Text('path: ${snapshot.data!.path}');
//       } else {
//         text = const Text('path unavailable');
//       }
//     }
//     return Padding(padding: const EdgeInsets.all(16.0), child: text);
//   }
//
//   Widget _buildDirectories(
//       BuildContext context, AsyncSnapshot<List<Directory>?> snapshot) {
//     Text text = const Text('');
//     if (snapshot.connectionState == ConnectionState.done) {
//       if (snapshot.hasError) {
//         text = Text('Error: ${snapshot.error}');
//       } else if (snapshot.hasData) {
//         final String combined =
//         snapshot.data!.map((Directory d) => d.path).join(', ');
//         text = Text('paths: $combined');
//       } else {
//         text = const Text('path unavailable');
//       }
//     }
//     return Padding(padding: const EdgeInsets.all(16.0), child: text);
//   }
//
//   void _requestAppDocumentsDirectory() {
//     setState(() {
//       _appDocumentsDirectory = getApplicationDocumentsDirectory();
//     });
//   }
//
//   void _requestAppSupportDirectory() {
//     setState(() {
//       _appSupportDirectory = getApplicationSupportDirectory();
//     });
//   }
//
//   void _requestAppLibraryDirectory() {
//     setState(() {
//       _appLibraryDirectory = getLibraryDirectory();
//     });
//   }
//
//   void _requestExternalStorageDirectory() {
//     setState(() {
//       _externalDocumentsDirectory = getExternalStorageDirectory();
//     });
//   }
//
//   void _requestExternalStorageDirectories(StorageDirectory type) {
//     setState(() {
//       _externalStorageDirectories = getExternalStorageDirectories(type: type);
//     });
//   }
//
//   void _requestExternalCacheDirectories() {
//     setState(() {
//       _externalCacheDirectories = getExternalCacheDirectories();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: ListView(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: const Text('Get Temporary Directory'),
//                 onPressed: _requestTempDirectory,
//               ),
//             ),
//             FutureBuilder<Directory?>(
//                 future: _tempDirectory, builder: _buildDirectory),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: const Text('Get Application Documents Directory'),
//                 onPressed: _requestAppDocumentsDirectory,
//               ),
//             ),
//             FutureBuilder<Directory?>(
//                 future: _appDocumentsDirectory, builder: _buildDirectory),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: const Text('Get Application Support Directory'),
//                 onPressed: _requestAppSupportDirectory,
//               ),
//             ),
//             FutureBuilder<Directory?>(
//                 future: _appSupportDirectory, builder: _buildDirectory),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: const Text('Get Application Library Directory'),
//                 onPressed: _requestAppLibraryDirectory,
//               ),
//             ),
//             FutureBuilder<Directory?>(
//                 future: _appLibraryDirectory, builder: _buildDirectory),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: Text(Platform.isIOS
//                     ? 'External directories are unavailable on iOS'
//                     : 'Get External Storage Directory'),
//                 onPressed:
//                 Platform.isIOS ? null : _requestExternalStorageDirectory,
//               ),
//             ),
//             FutureBuilder<Directory?>(
//                 future: _externalDocumentsDirectory, builder: _buildDirectory),
//             Column(children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   child: Text(Platform.isIOS
//                       ? 'External directories are unavailable on iOS'
//                       : 'Get External Storage Directories'),
//                   onPressed: Platform.isIOS
//                       ? null
//                       : () {
//                     _requestExternalStorageDirectories(
//                       StorageDirectory.music,
//                     );
//                   },
//                 ),
//               ),
//             ]),
//             FutureBuilder<List<Directory>?>(
//                 future: _externalStorageDirectories,
//                 builder: _buildDirectories),
//             Column(children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   child: Text(Platform.isIOS
//                       ? 'External directories are unavailable on iOS'
//                       : 'Get External Cache Directories'),
//                   onPressed:
//                   Platform.isIOS ? null : _requestExternalCacheDirectories,
//                 ),
//               ),
//             ]),
//             FutureBuilder<List<Directory>?>(
//                 future: _externalCacheDirectories, builder: _buildDirectories),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ScreenshotController screenshotController = ScreenshotController();
  void _incrementCounter() async{


    var container = Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 5.0),
          color: Colors.redAccent,
        ),
        child: Text(
          "This is an invisible widget",
          style: Theme.of(context).textTheme.headline6,
        ));
    screenshotController
        .captureFromWidget(
        InheritedTheme.captureAll(
            context, Material(child: container)),
        delay: Duration(seconds: 1))
        .then((capturedImage) async {
        final file = await _localFile;

        // print("bkbjbkjbjk====${data.toString()}");

        ByteData bytes = await rootBundle.load('images/download.png');
        print("checkImage---${bytes.toString()}");
        final buffer = bytes.buffer;
        // File('thumbnail.png').writeAsBytesSync([bytes]);
      // var data =  await file.writeAsBytes(
      //       buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

       file.writeAsBytesSync(capturedImage);

        // print("checkImagedata---${data.toString()}");
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.png');
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
