import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mustafa_nito/model/adjust_screen.dart';
import 'package:project_mustafa_nito/router/router.dart' as router;
import 'package:project_mustafa_nito/model/capitalise.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SubjectMetric extends StatefulWidget {
  SubjectMetric({Key key, this.title, this.board}) : super(key: key);
  final String title;
  final String board;

  @override
  _SubjectState createState() => new _SubjectState();
}

class _SubjectState extends State<SubjectMetric> {
  Set<String> allSubjectsFromFirebase = Set<String>();
  Set<String> subjectsAlreadyFavourite = Set<String>();
  List<String> tempList = List<String>();
  var items = List<String>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _showClearButton = _textEditingController.text.length > 0;
      });
    });
    // _read().then((val) {
    //   tempList.addAll(val);
    //   print("the stored sharedPrefrences data _read below");
    //   print(tempList);
    // });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    SizeConfig().init(context);
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 8),
        child: Container(
            // height: 50,
            height: SizeConfig.blockSizeVertical * 7.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                //color: Colors.amber[colorCodes[index]],
                gradient: LinearGradient(
                  colors: [Color(0xff000450), Color(0xff004e92)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
            child: Center(
                child: ListTile(
              selected: true,
              title: Text(document['display_name'],
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      color: Colors.white)),
              // trailing: favouriteWidget(
              //   context,
              //   document["subject_name"],
              // ),
              onTap: () {
                Navigator.pushNamed(context, router.Router.paper_list,
                    arguments: (widget.board + "." + document['subject_name']));
              },
            ))));
  }

//
  bool _showClearButton = false;
  String search;
  @override
  Widget build(BuildContext context) {
    // Jugaar
    String data = widget.board;
    List<String> argData = (data.split('.'));
    print(data);
// [bezkoder, earth, com]
    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: new AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              argData[1].capitalize() + ' ' + 'Board',
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 4,
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
                // Text(widget.board),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                    child: Container(
                      padding: EdgeInsets.all(0),
                      // height: 40,
                      height: SizeConfig.blockSizeVertical * 5.5,
                      child: TextField(
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
                            labelText: "Search Subject",
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
                            .doc(argData[0])
                            .collection('Boards')
                            .doc(argData[1])
                            .collection('Subjects')
                            .orderBy('subject_name')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('Level')
                            .doc(argData[0])
                            .collection('Boards')
                            .doc(argData[1])
                            .collection('Subjects')
                            .orderBy('display_name')
                            .where("searchkeywords", arrayContains: search)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading');
                      return Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                snapshot.data.documents.length, //items.length,
                            itemBuilder: (context, index) {
                              allSubjectsFromFirebase.add(snapshot
                                  .data.documents[index]['subject_name']);
                              // print(allSubjectsFromFirebase.toList());
                              return _buildListItem(
                                  context, snapshot.data.documents[index]);
                            }),
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
      icon: Icon(
        Icons.clear,
        color: Colors.black,
      ),
    );
  }

  // _read() async {
  //   final sharedPrefInstance = await SharedPreferences.getInstance();
  //   final key = 'List_fav_subjects';
  //   final value = sharedPrefInstance.getStringList(key);
  //   return value;
  // }

  // _save(Set<String> favSubject) async {
  //   final sharedPrefInstance = await SharedPreferences.getInstance();
  //   // final key = 'List_fav_subjects';
  //   final value = favSubject;
  //   // sharedPrefInstance.setStringList(key, value);
  //   sharedPrefInstance.setStringList('List_fav_subjects',
  //       value.map((String item) => item.toString()).toList());
  //   print(value);
  // }

  // Widget favouriteWidget(BuildContext context, String sub) {
  //   StateSetter _setState;
  //   bool _isFavorited = false;
  //   Set<String> temporarySelectedFavSub = Set<String>();

  //   return StatefulBuilder(
  //       builder: (BuildContext context, StateSetter setstate) {
  //     _setState = setstate;
  //     // if (tempList.any((element) => allSubjectsFromFirebase
  //     // .map((String item) => item.toString())
  //     // .toList()
  //     // .contains(element)))
  //     print('_setState callled local builder');

  //     if (tempList.contains(sub)) {
  //       if (_isFavorited == false) _isFavorited = true;
  //     } else {
  //       if (_isFavorited == true) _isFavorited = false;
  //     }

  //     _isFavorited = true;
  //     return Container(
  //       padding: EdgeInsets.all(0),
  //       child: IconButton(
  //           icon: (_isFavorited
  //               ? Icon(Icons.favorite)
  //               : Icon(Icons.favorite_border)),
  //           color: Colors.white,
  //           //
  //           onPressed: () {
  //             _setState(() {
  //               // remove from favourite
  //               if (_isFavorited == true) {
  //                 _isFavorited = false;
  //                 //
  //                 temporarySelectedFavSub
  //                     .removeWhere((element) => element == sub);
  //                 subjectsAlreadyFavourite
  //                     .removeWhere((element) => element == sub);
  //                 print('Fav = false');
  //                 print(temporarySelectedFavSub);
  //                 print(subjectsAlreadyFavourite);
  //                 // add to favourite
  //               } else if (_isFavorited == false) {
  //                 _isFavorited = true;
  //                 //
  //                 temporarySelectedFavSub.add(
  //                     sub); // add selected subject to a list inorder to save it to memory
  //                 subjectsAlreadyFavourite.add(sub);
  //                 print('Fav = true, below are temp and already store subs');
  //                 print(temporarySelectedFavSub.toList());
  //                 print(subjectsAlreadyFavourite);
  //                 _save(
  //                     subjectsAlreadyFavourite); // call "_save" function to store the current element (in subjectsAlreadyFav) in localpath
  //               }
  //             });
  //           }),
  //     );
  //   });
  // }
}
