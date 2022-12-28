import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_mustafa_nito/model/adjust_screen.dart';
import 'package:project_mustafa_nito/router/router.dart' as router;

class EducationBoardMetric extends StatefulWidget {
  EducationBoardMetric({Key key, this.title, this.boardType}) : super(key: key);
  final String title;
  final String boardType;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<EducationBoardMetric> {
  var items = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _showClearButton = _textEditingController.text.length > 0;
      });
    });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    SizeConfig().init(context);
    String previousdata = widget.boardType;
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 8),
        child: Container(
            // height: 50,
            height: SizeConfig.blockSizeVertical * 7.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                //color: Colors.amber[colorCodes[index]],
                gradient: LinearGradient(
                  colors: [Color(0xff614385), Color(0xff516395)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
            child: ListTile(
              selected: true,
              title: Text(document['name'],
                  style: TextStyle(
                    color: Colors.white,
                    // fontSize: 16,
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                  )),
              // trailing: FavouriteWidget(),
              // Icon(
              //   ,
              //   Icons.favorite_border,
              //   color: Colors.white,
              // ),
              onTap: () {
                Navigator.pushNamed(context, router.Router.subject_metric,
                    arguments: (previousdata + "." + document['id']));
              },
            )));
  }

  bool _showClearButton = false;
  String search;
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          // backgroundColor: Colors.red,
          appBar: new AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              widget.boardType,
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 4.15,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue[300],
                ),
                onPressed: () {
                  Navigator.maybePop(context);
                }),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                // Text(widget.boardType),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                    child: Container(
                      // height: 40,
                      height: SizeConfig.blockSizeVertical * 5.5,
                      child: TextField(
                        autofocus: false,
                        onChanged: (value) {
                          setState(() {
                            search = value.toLowerCase();
                            if (search.length == 0) {
                              search = null;
                            }
                          });
                        },
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            labelText: "Search Board",
                            // hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: _getClearButton(),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)))),
                      ),
                    )),
                StreamBuilder(
                    stream: (search == null)
                        ? FirebaseFirestore.instance
                            .collection('Level')
                            .doc(widget.boardType)
                            .collection('Boards')
                            .orderBy('name')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('Level')
                            .doc(widget.boardType)
                            .collection('Boards')
                            .orderBy('name')
                            .where("searchkeywords", arrayContains: search)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading');
                      return Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                snapshot.data.docs.length, //items.length,
                            itemBuilder: (context, index) => _buildListItem(
                                context, snapshot.data.docs[index])),
                      );
                    })
              ],
            ),
          )),
    );
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return IconButton(
      onPressed: () {
        _textEditingController.clear();
        FocusScope.of(context).unfocus();
        search = null;
      },
      icon: Icon(Icons.clear),
    );
  }
}
