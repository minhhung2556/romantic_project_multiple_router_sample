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
        final routeName = settings.name;
        final rootPath = getPathAfter(null, routeName);
        switch (rootPath) {
          case AppRouters.PC3:
            return MaterialPageRoute(
              builder: (context) => SubApp(
                theme: ThemeData(
                  primarySwatch: Colors.amber,
                ),
                subRouteWidgetBuilders:
                    AppRouters.subRouteWidgetBuilders[rootPath],
                rootPath: rootPath,
                home: _createPagePC3(),
                page404: _createPage404(),
              ),
              settings: settings,
            );
          case AppRouters.ORDER_HISTORY:
            return MaterialPageRoute(
              builder: (context) => SubApp(
                theme: ThemeData(
                  primarySwatch: Colors.lightGreen,
                ),
                subRouteWidgetBuilders:
                    AppRouters.subRouteWidgetBuilders[rootPath],
                rootPath: rootPath,
                home: _createPageORDER_HISTORY(),
                page404: _createPage404(),
              ),
              settings: settings,
            );
          default:
            return MaterialPageRoute(builder: (context) => _createPage404());
        }
      },
      home: _createHomeApp(),
    );
  }
}

class AppRouters {
  static const PC3 = 'tien-ich';
  static const ORDER_HISTORY = 'don-hang-tien-ich';

  static final subRouteWidgetBuilders =
      <String, Map<String, SubRouteWidgetBuilder>>{
    PC3: <String, SubRouteWidgetBuilder>{
      've-may-bay': (String originUri, String rootPath, String destPath,
          RouteSettings settings, BuildContext context) {
        if (destPath == null)
          return _createPagePC3_VMB();
        else if (destPath == 'chon-san-bay')
          return _createPagePC3_VMB_CSB();
        else
          return null;
      },
      'hoa-don': (String originUri, String rootPath, String destPath,
          RouteSettings settings, BuildContext context) {
        if (destPath == null)
          return _createPagePC3_HD();
        else if (destPath == 'dien')
          return _createPagePC3_HD_DIEN();
        else
          return null;
      }
    },
    ORDER_HISTORY: <String, SubRouteWidgetBuilder>{
      'chi-tiet': (String originUri, String rootPath, String destPath,
          RouteSettings settings, BuildContext context) {
        if (destPath == null)
          return _createPageORDER_HISTORY_CHITIET();
        else
          return null;
      },
    },
  };
}

Widget _createPage404() => SamplePage(
      title: '404',
    );

Widget _createHomeApp() => SamplePage(
      title: 'Multiple Routers Sample',
      nextRouteNames: ['tien-ich', 'don-hang-tien-ich', 'page3'],
    );

Widget _createPagePC3() => SamplePage(
      title: 'tien-ich',
      nextRouteNames: ['tien-ich/ve-may-bay', 'tien-ich/hoa-don'],
    );

Widget _createPagePC3_VMB() => SamplePage(
      title: 'tien-ich/ve-may-bay',
      nextRouteNames: [
        'tien-ich/ve-may-bay/chon-san-bay',
        'tien-ich/ve-may-bay/page112',
      ],
    );
Widget _createPagePC3_VMB_CSB() => SamplePage(
      title: 'tien-ich/ve-may-bay/chon-san-bay',
    );
Widget _createPagePC3_HD() => SamplePage(
      title: 'tien-ich/hoa-don',
      nextRouteNames: ['tien-ich/hoa-don/dien'],
    );
Widget _createPagePC3_HD_DIEN() => SamplePage(
      title: 'tien-ich/hoa-don/dien',
    );

Widget _createPageORDER_HISTORY() => SamplePage(
      title: AppRouters.ORDER_HISTORY,
      nextRouteNames: ['${AppRouters.ORDER_HISTORY}/chi-tiet'],
    );

Widget _createPageORDER_HISTORY_CHITIET() => SamplePage(
      title: '${AppRouters.ORDER_HISTORY}/chi-tiet',
    );
