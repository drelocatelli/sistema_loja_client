 import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';

Future<void> printDoc(BuildContext context, Widget widget, {bool minified = false}) async {
  ScreenshotController screenshotController = ScreenshotController();
  
  Widget wrappedWidget = MediaQuery(
    data: new MediaQueryData(),
    child: new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SharedTheme.main(),
      home: Scaffold(body: widget),
    )
  );

  
  Uint8List? screenShot = await screenshotController.captureFromWidget(wrappedWidget, targetSize: minified ? null : Size(1280, Get.height));

  
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return  pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain);
      },
    ),
  );
  final pdfData = await pdf.save();
  await Printing.layoutPdf(
      onLayout: (format) async => pdfData);
}