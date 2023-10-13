import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as img;

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'globals.dart';
// import 'dart:typed_data';

class GeniusScanner extends StatefulWidget {
  const GeniusScanner({super.key});

  @override
  State<GeniusScanner> createState() => _GeniusScannerState();
}

class _GeniusScannerState extends State<GeniusScanner> {
  // list of images
  // List<String> _pictures = [];
  // var _data;

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
        // _data = result['scans']['enhancedUrl'];
        // setState(() {
        //   _pictures = data;
        // });
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
