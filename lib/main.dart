import 'package:flutter/material.dart';
import 'package:project_mustafa_nito/router/router.dart' as router;

void main() {
  runApp(MyApp());
}
// Press F5 to run this code in Debug - PixelPhone conditions True

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: router.Router.home_screen,
      onGenerateRoute: router
          .Router.generateRoute, //navigator.pushNamed(contxt,Router.<anything>)
    );
  }
}
