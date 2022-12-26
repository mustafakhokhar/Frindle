import 'package:flutter/material.dart';
import 'package:project_mustafa_nito/model/adjust_screen.dart';

class SettingsPage extends StatefulWidget {
  final String info;
  SettingsPage({this.info});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String data = widget.info;
    List<String> argData = (data.split(','));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff141e30),
        title: Text("Settings"),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Align(
                  child: Container(
                height: MediaQuery.of(context).size.height / 7,
                // child: Column(
                //   children: [
                //     Text(
                //       argData[3],
                //       style: TextStyle(
                //           fontSize: 20,
                //           color: Colors.blue[900],
                //           fontWeight: FontWeight.bold),
                //     ),
                //     Container(
                //       width: MediaQuery.of(context).size.width,
                //       padding: EdgeInsets.all(0),
                //       child: Center(
                //           child: Text(
                //         argData[4],
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 12,
                //             fontWeight: FontWeight.w600,
                //             letterSpacing: 1),
                //       )),
                //     ),
                //   ],
                // ),
              )),
              Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        // color: Colors.pink,
                        height: MediaQuery.of(context).size.height / 6.5,
                        child: Column(
                          children: [
                            Text(
                              argData[1],
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(0),
                              child: Center(
                                  child: Text(
                                argData[2],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1),
                              )),
                            ),
                          ],
                        ),
                      ))),
            ],
          )),
    );
  }
}
