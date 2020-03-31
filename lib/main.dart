import 'package:flutter/material.dart';
import 'package:multiple_router_sample/sub_app.dart';

import 'sample_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        final url = settings.name;
        final path1 = getPathAfter(null, url);
        switch (path1) {
          case 'tien-ich':
            return MaterialPageRoute(
              builder: (context) => SubApp(
                theme: ThemeData(
                  primarySwatch: Colors.amber,
                ),
                originUri: Uri.tryParse(url),
                rootPath: path1,
                onGenerateRouteWidget:
                    (originUri, destPath, settings, context) {
                  return SubRouteWidget(
                          builder: SubRouteConstants
                              .subRouteWidgetBuilders[destPath],
                          originUri: originUri,
                          rootPath: destPath,
                          settings: settings)
                      .build(context);
                },
                home: _createPage1(),
                page404: SamplePage(
                  title: '404',
                ),
              ),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
                builder: (context) => SamplePage(
                      title: path1,
                    ));
        }
      },
      home: _pageHome(),
    );
  }
}

Widget _pageHome() => SamplePage(
      title: 'Home',
      nextRouteNames: ['tien-ich', 'page2', 'page3'],
    );

Widget _createPage1() => SamplePage(
      title: 'tien-ich',
      nextRouteNames: ['tien-ich/ve-may-bay', 'tien-ich/hoa-don'],
    );

Widget _createPage11() => SamplePage(
      title: 'tien-ich/ve-may-bay',
      nextRouteNames: [
        'tien-ich/ve-may-bay/chon-san-bay',
        'tien-ich/ve-may-bay/page112',
      ],
    );
Widget _createPage111() => SamplePage(
      title: 'tien-ich/ve-may-bay/chon-san-bay',
    );
Widget _createPage12() => SamplePage(
      title: 'tien-ich/hoa-don',
      nextRouteNames: ['tien-ich/hoa-don/dien'],
    );
Widget _createPage121() => SamplePage(
      title: 'tien-ich/hoa-don/dien',
    );

class SubRouteConstants {
  static final subRouteWidgetBuilders = <String, SubRouteWidgetBuilder>{
    've-may-bay': (Uri originUri, String rootPath, String destPath,
        RouteSettings settings, BuildContext context) {
      if (destPath == null)
        return _createPage11();
      else if (destPath == 'chon-san-bay')
        return _createPage111();
      else
        return null;
    },
    'hoa-don': (Uri originUri, String rootPath, String destPath,
        RouteSettings settings, BuildContext context) {
      if (destPath == null)
        return _createPage12();
      else if (destPath == 'dien')
        return _createPage121();
      else
        return null;
    },
  };
}
