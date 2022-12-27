import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_mustafa_nito/model/adjust_screen.dart';
import 'package:project_mustafa_nito/router/router.dart' as router;

class PaperTemplate extends StatefulWidget {
  PaperTemplate({Key key, this.title, this.paper}) : super(key: key);
  final String title;
  final String paper;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<PaperTemplate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _rangeToTextEditingController =
      TextEditingController();
  final TextEditingController _rangeFromTextEditingController =
      TextEditingController();
  Map<int, Widget> mytabs;
  String search;
  String type;
  bool ismetric;
  bool _showClearButton = false;
  bool _showRangeToClearButton = false;
  bool _showRangeFromClearButton = false;
//
  int selectedValue;
  bool isYearSelected;
  // ignore: non_constant_identifier_names
  bool isAKU_EB = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _showClearButton = _textEditingController.text.length > 0;
      });
    });
    _rangeToTextEditingController.addListener(() {
      setState(() {
        _showRangeToClearButton = _rangeToTextEditingController.text.length > 0;
      });
    });
    _rangeFromTextEditingController.addListener(() {
      setState(() {
        _showRangeFromClearButton =
            _rangeFromTextEditingController.text.length > 0;
      });
    });
    isYearSelected = true;
  }

//
  int segmentedControlGroupValue = 0;
  final Map<int, Widget> metricTabs = <int, Widget>{
    0: Text(
      "All",
      style: TextStyle(
        fontSize: SizeConfig.safeBlockHorizontal * 4,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    1: Text(
      "SSC-I",
      style: TextStyle(
        fontSize: SizeConfig.safeBlockHorizontal * 4,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        decorationColor: Colors.white,
      ),
    ),
    2: Text(
      "SSC-II",
      style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    ),
  };

  final Map<int, Widget> interTabs = <int, Widget>{
    0: Text(
      "All",
      style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    ),
    1: Text(
      "HSSC-I",
      style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    ),
    2: Text(
      "HSSC-II",
      style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    ),
  };

  int segmentedControlGroupValueYear = 0;
  final Map<int, Widget> yearTab = const <int, Widget>{
    // 0: Text(
    //   "None",
    //   style: TextStyle(
    //       fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
    // ),
    0: Text(
      "Specific",
      style: TextStyle(
          fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
    ),
    1: Text(
      "Range",
      style: TextStyle(
          fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
    ),
  };

  int controlGroupValueAKUEB = 0;
  final Map<int, Widget> multiScreenTab = <int, Widget>{
    0: Text(
      "All",
      style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    ),
    1: Text(
      "QP",
      style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    ),
    2: Text(
      "MS",
      style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    ),
  };

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
                  colors: [Color(0xff141e30), Color(0xff243b55)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
            child: ListTile(
              dense: true,
              isThreeLine: (document['sub'] == null) ? false : true,
              selected: true,
              title: Text(document['name'],
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      color: Colors.white)),
              subtitle: (document['sub'] == null)
                  ? null
                  : Text(document['sub'],
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 2.9,
                          color: Colors.white)),
              trailing: Text(
                document['year'],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.bold),
              ),
              // Icon(
              //   ,
              //   Icons.favorite_border,
              //   color: Colors.white,
              // ),
              onTap: () {
                Navigator.pushNamed(context, router.Router.LOAD_PDF_FIR_STORAGE,
                    arguments: (document['name'] +
                        " " +
                        document['year'] +
                        "," +
                        document['pdfpath']));
              },
            )));
  }

  StateSetter _setState;
  showMenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.all(16),
              contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                        search_from = null;
                        search_to = null;
                        search = null;
                        _textEditingController.clear();
                        _rangeToTextEditingController.clear();
                        _rangeFromTextEditingController.clear();
                      },
                      child: new Padding(
                        padding: new EdgeInsets.all(0.0),
                        child: new Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setstate) {
                _setState = setstate;
                return Stack(
                  // fit: StackFit.loose,
                  // overflow: Overflow.visible,
                  children: <Widget>[
                    Column(
                      key: _formKey,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            // color: Colors.pink,
                            child: Column(children: [
                          SizedBox(
                            // height: 4,
                            height: SizeConfig.blockSizeVertical * 1,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Year",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            // height: 4,
                            height: SizeConfig.blockSizeVertical * 1,
                          ),
                          Container(
                            // color: Colors.pink,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: CupertinoSlidingSegmentedControl(
                                thumbColor: Colors.white,
                                backgroundColor: Colors.blueGrey[200],
                                groupValue: segmentedControlGroupValueYear,
                                children: yearTab,
                                onValueChanged: (k) {
                                  _setState(() {
                                    segmentedControlGroupValueYear = k;
                                    if (k == 0) {
                                      _setState(() {
                                        isYearSelected = true;
                                      });
                                    } else if (k == 1) {
                                      _setState(() {
                                        isYearSelected = false;
                                      });
                                    }
                                  });
                                }),
                          ),
                          // child,
                          Container(
                              // color: Colors.pink,
                              // width: MediaQuery.of(context).size.width,
                              width: SizeConfig.blockSizeHorizontal * 84,
                              // height: 45,
                              height: SizeConfig.blockSizeVertical * 6.5,
                              child: (isYearSelected)
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                        child: Container(
                                            padding: EdgeInsets.all(0),
                                            // height: 40,
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    6,
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width /
                                            //     2.75,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    36,
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                _setState(() {
                                                  search = value.toLowerCase();
                                                  if (isYearSelected = true) {
                                                    search_from = search;
                                                    search_to = search;
                                                  }
                                                  if (search.length == 0) {
                                                    search = null;
                                                  }
                                                });
                                              },
                                              controller:
                                                  _textEditingController,
                                              decoration: InputDecoration(
                                                  labelText: "Year",
                                                  suffixIcon: _getClearButton(),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)))),
                                            )),
                                      ))
                                  : FittedBox(
                                      fit: BoxFit.fill,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Container(
                                                padding: EdgeInsets.all(0),
                                                // height: 40,
                                                height: SizeConfig
                                                        .blockSizeVertical *
                                                    6,
                                                // width: MediaQuery.of(context)
                                                //         .size
                                                //         .width /
                                                //     2.75,
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    36,
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    _setState(() {
                                                      search_from =
                                                          value.toLowerCase();
                                                      if (search.length == 0) {
                                                        search = null;
                                                      }
                                                    });
                                                  },
                                                  controller:
                                                      _rangeFromTextEditingController,
                                                  decoration: InputDecoration(
                                                      labelText: "Year",
                                                      suffixIcon:
                                                          _getClearButtonRangeFrom(),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0)))),
                                                )),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      14, 0, 14, 10),
                                              child: Text(
                                                'To',
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        4.25),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Container(
                                                padding: EdgeInsets.all(0),
                                                // height: 40,
                                                height: SizeConfig
                                                        .blockSizeVertical *
                                                    6,
                                                // width: MediaQuery.of(context)
                                                //         .size
                                                //         .width /
                                                //     2.75,
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    36,
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    _setState(() {
                                                      search_to =
                                                          value.toLowerCase();
                                                      if (search.length == 0) {
                                                        search = null;
                                                      }
                                                    });
                                                  },
                                                  controller:
                                                      _rangeToTextEditingController,
                                                  decoration: InputDecoration(
                                                      labelText: "Year",
                                                      suffixIcon:
                                                          _getClearButtonRangeTo(),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0)))),
                                                )),
                                          ),
                                        ],
                                      )))
                        ])),
                      ],
                    ),
                  ],
                );
              }));
        });
  }

  var child;
  String nature;
  // ignore: non_constant_identifier_names
  String search_from;
  // ignore: non_constant_identifier_names
  String search_to;
  // bool multiscreen;
  String data;
  @override
  Widget build(BuildContext context) {
    String data = widget.paper;
    List<String> argData = (data.split('.'));
    print(data);
    if (argData[0].contains('Matriculate')) {
      ismetric = true;
      mytabs = metricTabs;
    } else {
      ismetric = false;
      mytabs = interTabs;
    }
    if (argData[1].contains('aghakhan')) {
      isAKU_EB = true;
    } else {
      isAKU_EB = false;
    }
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
              argData[2],
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 4.3,
              ),
            ),
            centerTitle: true,
            leading: Container(
                // key: _key,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff141e30),
                    ),
                    onPressed: () {
                      Navigator.maybePop(context);
                    })),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
                onPressed: () {
                  showMenu();
                  HapticFeedback.selectionClick();
                },
              )
            ],
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  // width: MediaQuery.of(context).size.width,
                  width: SizeConfig.blockSizeHorizontal * 100,
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
                  child: CupertinoSlidingSegmentedControl(
                      thumbColor: Colors.white,
                      backgroundColor: Colors.blueGrey[200],
                      groupValue: segmentedControlGroupValue,
                      children: mytabs,
                      onValueChanged: (i) {
                        setState(() {
                          segmentedControlGroupValue = i;
                          switch (ismetric) {
                            case (true):
                              switch (i) {
                                case (1):
                                  type = 'ssc-1';
                                  break;
                                case (2):
                                  type = 'ssc-2';
                                  break;
                                case (0):
                                  type = null;
                              }
                              break;
                            case (false):
                              switch (i) {
                                case (1):
                                  type = 'hssc-1';
                                  break;
                                case (2):
                                  type = 'hssc-2';
                                  break;
                                case (0):
                                  type = null;
                              }
                              break;
                          }
                        });
                      }),
                ),
                Container(
                  // color: Colors.blue,
                  child: (isAKU_EB)
                      ? Container(
                          // width: MediaQuery.of(context).size.width,
                          width: SizeConfig.blockSizeHorizontal * 90,
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 13),
                          child: CupertinoSlidingSegmentedControl(
                              thumbColor: Colors.white,
                              backgroundColor: Colors.blueGrey[200],
                              groupValue: controlGroupValueAKUEB,
                              children: multiScreenTab,
                              onValueChanged: (m) {
                                setState(() {
                                  HapticFeedback.lightImpact();
                                  controlGroupValueAKUEB = m;
                                  if (m == 1) {
                                    nature = 'qp';
                                  } else if (m == 2) {
                                    nature = 'ms';
                                  } else {
                                    nature = null;
                                  }
                                });
                              }),
                        )
                      : SizedBox(height: 0),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Level')
                        .doc(argData[0])
                        .collection('Boards')
                        .doc(argData[1])
                        .collection('Subjects')
                        .doc(argData[2])
                        .collection('Papers')
                        .orderBy('year', descending: true)
                        // .startAt(['2019'])
                        // .endAt(['2018'])
                        .where('id', isEqualTo: type)
                        .where('year',
                            isLessThanOrEqualTo: search_to) //upper bound
                        .where('year',
                            isGreaterThanOrEqualTo: search_from) //lower bound
                        // .where('id', whereIn: ['hssc-1'])
                        .where('nature', isEqualTo: nature)
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
                    }),
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
        // search_from = null;
        search = null;
        search_to = null;
      },
      icon: Icon(
        Icons.clear,
        color: Colors.black,
      ),
    );
  }

  Widget _getClearButtonRangeFrom() {
    // if (!_showRangeFromClearButton) {
    //   return null;
    // }
    return IconButton(
      onPressed: () {
        _rangeFromTextEditingController.clear();
        FocusScope.of(context).unfocus();
        search_from = null;
        search = null;
      },
      icon: Icon(
        Icons.clear,
        color: Colors.black,
      ),
    );
  }

  Widget _getClearButtonRangeTo() {
    // if (!_showRangeToClearButton) {
    //   return null;
    // }
    return IconButton(
      onPressed: () {
        // _rangeToTextEditingController.clear();
        _rangeToTextEditingController.clear();
        FocusScope.of(context).unfocus();
        search_to = null;
        search = null;
        // search_to = null;
      },
      icon: Icon(
        Icons.clear,
        color: Colors.black,
      ),
    );
  }
}

//-----------------------------------------------------------------------------------------------
