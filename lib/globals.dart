import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:math';

class EditDocument {
  createPDF(List<String> imagePaths, pdfDocument) async {
    // loop through array of iamges
    for (var imagePath in imagePaths) {
      final image = pw.MemoryImage(File(imagePath).readAsBytesSync());

      pdfDocument.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        },
      ));
    }
    savePDF(pdfDocument);
  }

  String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

// this function saves the converted pdf documents
  savePDF(pdfDocument) async {
    String randomString = generateRandomString(8);

    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/document_$randomString.pdf');
      await file.writeAsBytes(await pdfDocument.save());
      print('SAVED!!!!!');
    } catch (e) {
      print(e);
    }
  }
}
