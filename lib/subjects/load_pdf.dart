import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:project_mustafa_nito/model/adjust_screen.dart';

import 'package:project_mustafa_nito/subjects/mobile_pdf.dart';

String file = "How_To_Create_An_App.pdf";
String fileName = "Flutter Slides";

class Data {
  final String path;
  Data({this.path});
}

class LoadFirbaseStoragePdf extends StatefulWidget {
  final String file;
  const LoadFirbaseStoragePdf({this.file});

  @override
  _LoadFirbaseStoragePdfState createState() => _LoadFirbaseStoragePdfState();
}

class _LoadFirbaseStoragePdfState extends State<LoadFirbaseStoragePdf> {
  static String pathPDF = "";
  static String pdfUrl = "";
  bool connection = false;
  @override
  void initState() {
    super.initState();
    String data = widget.file;
    List<String> argData = (data.split(','));
    print(data);
    file = argData[
        1]; // "file" refer to file name in firebase cloud storage, which acts as a url link to open from.
    //Fetch file from FirebaseStorage first
    LaunchFile.loadPdfFromStorgae(
            file) // url here is the "file" location in firebase.
        .then((f) {
      setState(
        () {
          if (f != false) {
            pathPDF = f.path;
            Navigator.pop(context);
            LaunchFile.launchPDF(context, argData[0], pathPDF, pdfUrl);
            print('Condiiton 1: Already Saved, loading from storage');
          } else {
            print('Condiiton 2: NOT Saved, Try loading from Firebase');
            isInternet().then((value) {
              if (value == true) {
                LaunchFile.loadFromFirebase(context, file)
                    //Creating PDF file at disk for ios and android
                    .then((url) => LaunchFile.createFileFromPdfUrl(url,
                            file) // url here is the "file" location in firebase.
                        .then(
                          (f) => setState(
                            () {
                              pathPDF = f.path;
                              print(
                                  'Condiiton 3: Internet = true, Fetching from firebase');
                            },
                          ),
                        )
                        .then((value) => Navigator.pop(context))
                        .then((value) => LaunchFile.launchPDF(
                            context, argData[0], pathPDF, pdfUrl)));
              } else {
                // LaunchFile.loadPdfFromStorgae(
                //         file) // url here is the "file" location in firebase.
                // .then((f) {
                // setState(
                //   () {
                // if (f != false) {
                // pathPDF = f.path;
                // Navigator.pop(context);
                // LaunchFile.launchPDF(
                //     context, argData[0], pathPDF, pdfUrl);
                // print(
                //     'Condiiton 4: Internet = false, loading from storage');
                // } else {
                Navigator.pop(context);
                print('Condiiton 5: Internet = false, There is no file');
                showMenu();
                // }
                // },
                // );
                // }
                // );
              }
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: LoadingOverlay(
            isLoading: true,
            child: Container(
              padding: const EdgeInsets.all(16.0),
            ),
            opacity: 0.8,
            // color: Color(0xff141e30),
            color: Colors.black.withOpacity(0.8),
            progressIndicator: Container(
                padding: EdgeInsets.all(16),
                // color: Colors.black.withOpacity(0.8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpinKitWave(
                        itemCount: 6,
                        size: SizeConfig.blockSizeHorizontal * 12,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
                      _getHeading(),
                    ]))));
  }

  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        return true;
      } else {
        // Wifi detected but no internet connection found.
        return false;
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      return false;
    }
  }

  showMenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(insetPadding: EdgeInsets.all(16),
              // contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              actions: [
                Column(
                  children: [
                    Container(
                      // color: Colors.red,
                      height: SizeConfig.blockSizeVertical * 6,
                      width: SizeConfig.blockSizeHorizontal * 62,
                      child: Center(
                        child: Text('No internet connection',
                            style: TextStyle(
                                fontSize:
                                    SizeConfig.safeBlockHorizontal * 4.5)),
                      ),
                    ),
                    InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: new Padding(
                        padding: new EdgeInsets.all(0.0),
                        child: new Text(
                          "Ok",
                          style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ]);
        });
  }
}

// Widget _getLoadingIndicator() {
//   return Padding(
//       child: Container(
//         child: CircularProgressIndicator(strokeWidth: 3),
//         // width: 32,
//         // height: 32
//       ),
//       padding: EdgeInsets.only(bottom: 16));
// }

Widget _getHeading() {
  return Padding(
      child: Text(
        'Please wait …',
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      padding: EdgeInsets.only(bottom: 4));
}

// Container(
//   padding: EdgeInsets.all(20.0),
//   child: const CircularProgressIndicator(
//     backgroundColor: Colors.white,
//   ),
// ),
