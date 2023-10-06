import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'globals.dart';
import 'dart:typed_data';

class GeniusScanner extends StatefulWidget {
  const GeniusScanner({super.key});

  @override
  State<GeniusScanner> createState() => _GeniusScannerState();
}

class _GeniusScannerState extends State<GeniusScanner> {
  // list of images
  List<String> _pictures = [];
  var _data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Genius Scan'),
        actions: [
          IconButton(
            onPressed: () {
              // saveDocuments(_data);
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: []),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: runGenius,
        child: const Icon(Icons.camera),
      ),
    );
  }

  // ListView ImageList() {
  //   return ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: _pictures.length,
  //       itemBuilder: (context, index) {
  //         return Stack(
  //           children: [
  //             Container(
  //               width: 400,
  //               padding: const EdgeInsets.all(8.0),
  //               child: FutureBuilder<void>(
  //                 future: _rotateItem(),
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.done) {
  //                     return Image.file(File(_pictures[index]),
  //                         fit: BoxFit.cover);
  //                   } else {
  //                     return Image.file(File(_pictures[index]));
  //                   }
  //                 },
  //               ),
  //             ),
  //             Row(
  //               children: [
  //                 IconButton(
  //                     onPressed: () {
  //                       _rotateItem();
  //                       print('image rotated!!!');
  //                     },
  //                     icon: Icon(Icons.rotate_left)),
  //                 IconButton(
  //                     onPressed: () {
  //                       _rotateItem();
  //                       print('image rotated!!!');
  //                     },
  //                     icon: Icon(Icons.rotate_right)),
  //                 IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
  //                 IconButton(
  //                     onPressed: () {
  //                       showDialog(
  //                           context: context,
  //                           builder: (BuildContext context) =>
  //                               _buildPopupDialog(context, index, _pictures));
  //                     },
  //                     icon: Icon(Icons.list)),
  //               ],
  //             ),
  //             Positioned(
  //               bottom: 30.0,
  //               left: 25.0,
  //               child: Text(
  //                 '$index',
  //                 style: const TextStyle(
  //                     fontWeight: FontWeight.bold, fontSize: 24.0),
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }

  // Widget _buildPopupDialog(
  //     BuildContext context, int index, List<String> imageArray) {
  //   return AlertDialog(
  //     title: const Text('Pick new page:'),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         for (var i = 0; i < imageArray.length; i++)
  //           TextButton(
  //               onPressed: () {
  //                 // print('button picked');
  //                 _swapItems(imageArray, index, i);
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("$i")),
  //       ],
  //     ),
  //     actions: <Widget>[
  //       TextButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         child: const Text('Close'),
  //       ),
  //     ],
  //   );
  // }

  void runGenius() async {
    // genius scan config
    // Create a GeniusScanConfiguration instance
    var configuration = {
      'source': 'camera',
      'multiPage': true,
      'defaultFilter': 'none',
      'pdfPageSize': 'a4',
      'jpegQuality': 80
    };

    try {
      var result = await FlutterGeniusScan.scanWithConfiguration(configuration);

      if (result['scans']) {
        // instantiate an object variable
        var data = result['scans'];
        _data = result['scans']['enhancedUrl'];
        var fileLink = result['multiPageDocumentUrl'];
        setState(() {
          _pictures = data;
        });
        // print(fileLink.toString());
        // print('SUCCESS!!!!!!!!!!!!!' + data);
        saveDocuments(data);
      }
    } catch (e) {}
  }

  void saveDocuments(Map pages) async {
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/geniusscan/');
    var config = {'outputFileUrl': file, 'pdfFontFileUrl': null};

    try {
      await FlutterGeniusScan.generateDocument(pages, config);
    } catch (e) {}
  }
}
