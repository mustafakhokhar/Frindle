import 'package:flutter/material.dart';

class FavouriteWidget extends StatefulWidget {
  // ignore: non_constant_identifier_names
  FavouriteWidget({Key key, this.sub_name_fav}) : super(key: key);
  // ignore: non_constant_identifier_names
  final String sub_name_fav;
  @override
  _FavouriteWidgetState createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  bool _isFavorited = false;
  String fav;
  List<String> favTrueList = [];
  //int _favoriteCount = 41;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      padding: EdgeInsets.all(0),
      child: IconButton(
          icon: (_isFavorited
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border)),
          color: Colors.white,
          onPressed: () {
            setState(() {
              if (_isFavorited) {
                _isFavorited = false;
                favTrueList
                    .removeWhere((element) => element == widget.sub_name_fav);
              } else {
                _isFavorited = true;
                fav = widget.sub_name_fav;
                favTrueList.add(fav);
                print(favTrueList);
              }
            });
          }),
    );
  }

  // toggleFavorite() {
  //   setState(() {
  //     if (_isFavorited) {
  //       _isFavorited = false;
  //       fav = false;
  //       favTrueList.removeWhere((element) => element == widget.sub_name_fav);
  //     } else {
  //       // _favoriteCount += 1;
  //       _isFavorited = true;
  //       fav = true;
  //       favTrueList.add(widget.sub_name_fav);
  //       print(favTrueList);
  //     }
  //   });
  //   return fav;
  // }
}
