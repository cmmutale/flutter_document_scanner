import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as img;

// import 'dart:async';
import 'globals.dart';
// import 'dart:typed_data';
import 'dart:io';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  List<String> _pictures = [];
  final pdfDocument = pw.Document();

  EditDocument pdfObject = EditDocument();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner'),
      ),
      body: _pictures.isNotEmpty
          ? Center(
              child: Column(
                children: [
                  imageView(),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        pdfObject.createPDF(_pictures, pdfDocument);
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                              SnackBar(content: Text('Document Saved!')));
                        setState(() {
                          _pictures = [];
                        });
                      },
                      child: Text('Save Document'))
                ],
              ),
            )
          : Center(
              child: ElevatedButton(
                  onPressed: () => startScanning(),
                  child: const Text('Please Scan Images...')),
            ),
    );
  }

  // list view of images
  CarouselSlider imageView() {
    return CarouselSlider.builder(
      options: CarouselOptions(
          height: 600, enableInfiniteScroll: false, aspectRatio: 16 / 9),
      itemCount: _pictures.length,
      itemBuilder: (context, index, realIndex) {
        final picture = _pictures[index];
        return buildImage(picture, index);
      },
    );
  }

  Widget buildImage(String picture, int index) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            color: Colors.grey,
            child: Image.file(
              File(picture),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context, index, _pictures));
                },
                icon: const Icon(Icons.list),
                iconSize: 32,
              ),
              Text('$index'),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context, index, _pictures));
                },
                icon: const Icon(Icons.list),
                iconSize: 32,
              ),
            ],
          )
        ],
      ),
    );
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

  void _swapItems(List<String> array, int a, int b) {
    final temp = array[a];
    array[a] = array[b];
    array[b] = temp;
    setState(() {
      _pictures = _pictures;
    });
  }
}
