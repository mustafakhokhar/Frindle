import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_mustafa_nito/subjects/mobile_storage.dart';
import 'package:project_mustafa_nito/subjects/load_pdf.dart';
import 'package:project_mustafa_nito/subjects/pdf_screen.dart';

class LaunchFile {
  static void launchPDF(
      BuildContext context, String title, String pdfPath, String pdfUrl) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PDFScreen(title, pdfPath, pdfUrl),
      ),
    );
  }

  static Future<dynamic> loadFromFirebase(
      BuildContext context, String url) async {
    return FireStorageService.loadFromStorage(context, file);
  }

  static Future<dynamic> createFileFromPdfUrl(
      // ignore: non_constant_identifier_names
      dynamic url,
      // ignore: non_constant_identifier_names
      String filename_used) async {
    // Jugaar
    String name;
    List<String> data = (filename_used.split('/'));
    if (data[1] == "federal") {
      name = data[2] + "-" + data[3];
    } else if (data[1] == "agha_khan") {
      name = data[3] + "-" + data[4];
    }
    print(filename_used);
    final filename = name;
    // filename_used; //I did it on purpose to avoid strange naming conflicts
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;

    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  // ignore: non_constant_identifier_names
  static Future<dynamic> loadPdfFromStorgae(String filename_load) async {
    // Jugaar
    String name;
    List<String> data = (filename_load.split('/'));
    if (data[1] == "federal") {
      name = data[2] + "-" + data[3];
    } else if (data[1] == "agha_khan") {
      name = data[3] + "-" + data[4];
    }
    print(filename_load);
    final filename = name;

    String directory = (await getApplicationDocumentsDirectory()).path;
    //Error neechay wala code
    if (await File('$directory/$filename').exists()) {
      print("File exists");
      return File('$directory/$filename');
    } else {
      print("File don't exists");
      return false;
    }
  }
}
