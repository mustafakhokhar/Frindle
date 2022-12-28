import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_mustafa_nito/model/adjust_screen.dart';
import 'package:project_mustafa_nito/router/router.dart' as router;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    SizeConfig().init(context);
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Container(
          // padding: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
          // height: 220,
          height:
              SizeConfig.blockSizeVertical * 10, //document.isEven ? 220 : 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(50.0)),
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, router.Router.board_metric,
                  arguments: (document['title']));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      document['title'],
                      //style: kTitleTextStyle,
                      style: TextStyle(
                          color: Colors.white,
                          // fontSize: 25
                          fontSize: SizeConfig.safeBlockHorizontal * 6),
                    )),
              ],
            ),
          ),
        ));
  }
// -----------------------------------------------------------------------------

  Widget _buildDrawer(BuildContext context, DocumentSnapshot document) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Container(
            // height: 50,
            height: SizeConfig.blockSizeVertical * 7.25,
            // color: Colors.green,
            child: Align(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  selected: true,
                  dense: true,
                  leading: Icon(
                    ((document['index'] == 1)
                        ? Icons.settings
                        : Icons.mail_outline),
                    color: Colors.blue[900],
                  ),
                  title: Text(document["text"],
                      style: TextStyle(
                          // fontSize: 20,
                          fontSize: SizeConfig.safeBlockHorizontal * 4.85,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w500)),
                  onTap: () {
                    document['index'] == 1
                        ? Navigator.pushNamed(context, router.Router.info_page,
                            arguments:
                                (document['text'] + "," + document['body1']))
                        : _launchURL(document.get('email'));

                    // if (document['index'] == 1) {
                    //   }
                    // else {
                    //   _launchURL(document.get('email'));
                    // }

                    // Navigator.pop(context);
                  },
                ))));
  }
// =============================================================================

  _launchURL(String toMailId) async {
    var url = Uri.parse('mailto:$toMailId?');
    if (await canLaunchUrl(url)) {
      launchUrl(url);
      print(url);
    } else {
      print(url);
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Padding(
            padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
            child: Text(
              "Select Level",
              style: TextStyle(
                  // fontSize: 25,
                  fontSize: SizeConfig.safeBlockHorizontal * 6,
                  color: Colors.black),
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Color(0xff141e30)),
        automaticallyImplyLeading: false,
      ),
      endDrawer: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Drawer_info')
            .orderBy('text', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Text(
              'Loading',
              style: TextStyle(fontSize: 20),
            );
          return Drawer(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AppBar(
                elevation: 4,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Text(
                  'Frindle',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Flexible(
                  child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      itemCount: snapshot.data.docs.length, //items.length,
                      itemBuilder: (context, index) =>
                          _buildDrawer(context, snapshot.data.docs[index]))),
              Container(
                // width: MediaQuery.of(context).size.width,
                // height: 50,
                height: SizeConfig.blockSizeVertical * 7.25,
                padding: EdgeInsets.all(0),
                child: Center(
                    child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.rocket_launch_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'mustafakhokhar',
                      style: TextStyle(
                          color: Colors.white,
                          // fontSize: 22,
                          fontSize: SizeConfig.safeBlockHorizontal * 5.35,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1),
                    ),
                  ],
                )),
                decoration: BoxDecoration(color: Color(0xff141e30)),
              ),
            ],
          ));
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 0, right: 20),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  // height: 10),
                  height: SizeConfig.blockSizeVertical * 1.25),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Level')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading');
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length, //items.length,
                          itemBuilder: (context, index) => _buildListItem(
                              context, snapshot.data.docs[index])),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

//   Future<void> _deleteAppDir() async {
//     final appDir = await getApplicationSupportDirectory();
//     if (appDir.existsSync()) {
//       appDir.deleteSync(recursive: true);
//     }
//   }
}
