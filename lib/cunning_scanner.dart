import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'globals.dart';
import 'dart:typed_data';

// import components
import 'compnents/appBar.dart';

class CunningScanner extends StatefulWidget {
  const CunningScanner({super.key});

  @override
  State<CunningScanner> createState() => _CunningScannerState();
}

class _CunningScannerState extends State<CunningScanner> {
  // list of pictures that will be taken
  List<String> _pictures = [];
  // edit image
  File? _editImge;
  // Document object for pdf
  final pdfDocument = pw.Document();

  // edit scanned documents
  EditDocument editObject = EditDocument();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cunning Scanner'),
        actions: [
          IconButton(
            onPressed: () {
              // createPDF(_pictures, pdfDocument);
              editObject.createPDF(_pictures, pdfDocument);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: ImageList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => startScanning(),
        child: const Icon(Icons.camera),
      ),
    );
  }

// Build list of images for editing
  ListView ImageList() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pictures.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                width: 400,
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<void>(
                  future: _rotateItem(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Image.file(File(_pictures[index]),
                          fit: BoxFit.cover);
                    } else {
                      return Image.file(File(_pictures[index]));
                    }
                  },
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _editImge = File(_pictures[index]);
                        _rotateItem();
                        print('image rotated!!!');
                      },
                      icon: Icon(Icons.rotate_left)),
                  IconButton(
                      onPressed: () {
                        _editImge = File(_pictures[index]);
                        _rotateItem();
                        print('image rotated!!!');
                      },
                      icon: Icon(Icons.rotate_right)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context, index, _pictures));
                      },
                      icon: Icon(Icons.list)),
                ],
              ),
              Positioned(
                bottom: 30.0,
                left: 25.0,
                child: Text(
                  '$index',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              )
            ],
          );
        });
  }

// popup widget for rearranging pages
  Widget _buildPopupDialog(
      BuildContext context, int index, List<String> imageArray) {
    return AlertDialog(
      title: const Text('Pick new page:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (var i = 0; i < imageArray.length; i++)
            TextButton(
                onPressed: () {
                  // print('button picked');
                  _swapItems(imageArray, index, i);
                  Navigator.of(context).pop();
                },
                child: Text("$i")),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

// start the cunning scanner
  void startScanning() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
    } catch (e) {}
  }

// swapping algorithme
  void _swapItems(List<String> array, int a, int b) {
    final temp = array[a];
    array[a] = array[b];
    array[b] = temp;
    setState(() {
      _pictures = _pictures;
    });
  }

// rotate images
  Future<void> _rotateItem() async {
    img.Image? image = img.decodeImage(await _editImge!.readAsBytes());
    img.Image rotatedImage = img.copyRotate(image!, angle: 90);

    Uint8List rotatedBytes = Uint8List.fromList(img.encodeJpg(rotatedImage));

    await _editImge?.writeAsBytes(rotatedBytes);

    setState(() {
      _pictures = _pictures;
    });
  }
}
