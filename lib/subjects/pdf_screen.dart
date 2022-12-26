import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

// ignore: must_be_immutable

// ignore: must_be_immutable
class PDFScreen extends StatelessWidget {
  String title = "";
  String pdfPath;
  String pdfUrl;
  PDFScreen(this.title, this.pdfPath, this.pdfUrl);

  static void popUntil(BuildContext context, RoutePredicate predicate) {
    Navigator.of(context).popUntil(predicate);
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                title,
                style: TextStyle(color: Colors.black),
              )),
          leading: InkWell(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
              }),
          elevation: 15.0,
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(
          //       Icons.share,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {

          //     },
          //   ),
          // ],
        ),
        path: pdfPath);
  }
}
