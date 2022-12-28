import 'package:flutter/cupertino.dart';
import 'package:project_mustafa_nito/screens/Papers_Template.dart';
import 'package:project_mustafa_nito/screens/home_type.dart';
import 'package:project_mustafa_nito/screens/metric_Boards.dart';
import 'package:project_mustafa_nito/screens/metric_subjects.dart';
import 'package:project_mustafa_nito/screens/settings_page.dart';
import 'package:project_mustafa_nito/subjects/load_pdf.dart';

class Router {
  static const String home_screen = '/home_screen';
  static const String board_metric = '/board_metric';
  static const String subject_metric = '/subject_metric';
  static const String paper_list = '/paper_list';
  static const String LOAD_PDF_FIR_STORAGE = 'LOAD_PDF_FIR_STORAGE';
  static const String info_page = '/settings_page';
  static const String example = '/example';
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home_screen:
        return CupertinoPageRoute(builder: (_) => HomeScreen());
      case info_page:
        var data = settings.arguments;
        return CupertinoPageRoute(builder: (_) => SettingsPage(info: data));
      case board_metric:
        var boardType = settings.arguments;
        return CupertinoPageRoute(
            builder: (context) => EducationBoardMetric(boardType: boardType));
      case paper_list:
        var paperSub = settings.arguments;
        return CupertinoPageRoute(
            builder: (context) => PaperTemplate(paper: paperSub));
      case LOAD_PDF_FIR_STORAGE:
        var filename = settings.arguments;
        //final ScreenArguments screenArgs = settings.arguments;
        return CupertinoPageRoute(
            builder: (context) => LoadFirbaseStoragePdf(
                  file: filename,
                  // pageName: screenArgs.pageName,
                  // recipeName: screenArgs.recipeName,
                  // codeFilePath: screenArgs.codeFilePath,
                  // codeGithubPath: screenArgs.codeGithubPath,
                ));
        break;
      case subject_metric:
        var board = settings.arguments;
        return CupertinoPageRoute(
            builder: (context) => SubjectMetric(board: board));
      // default:
      // return MaterialPageRoute(
      //     builder: (_) => Scaffold(
      //           body: Center(
      //               child: Text('No route defined for ${settings.name}')),
      //         ));
    }
  }
}
