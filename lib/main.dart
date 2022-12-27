import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_mustafa_nito/router/router.dart' as router;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
// Press F5 to run this code in Debug - PixelPhone conditions True

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: router.Router.home_screen,
            onGenerateRoute: router.Router
                .generateRoute, //navigator.pushNamed(contxt,Router.<anything>)
          );
        });
    // );
  }
}
