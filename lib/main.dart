import 'package:flutter/material.dart';
import 'package:multiple_router_sample/sub_app.dart';

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
          case 'page1':
            return MaterialPageRoute(
              builder: (context) => SubApp(
                theme: ThemeData(
                  primarySwatch: Colors.amber,
                ),
                originUri: Uri.tryParse(settings.name),
                appPath: path1,
                onGenerateRouteWidget: (originUri, destPath, settings) {
                  switch (destPath) {
                    case 'page11':
                      return SubRouteWidgetBuilder((builder, childDestPath) {
                        if (childDestPath == 'page111')
                          return SamplePage(
                            title: childDestPath,
                          );
                        else
                          return SamplePage(
                            title: destPath,
                            nextRouteName: 'page1/page11/page111',
                          );
                      },
                              originUri: originUri,
                              path: destPath,
                              settings: settings)
                          .build(context);
                    case 'page12':
                      return SubRouteWidgetBuilder((builder, childDestPath) {
                        if (childDestPath == 'page121')
                          return SamplePage(
                            title: childDestPath,
                          );
                        else
                          return SamplePage(
                            title: destPath,
                            nextRouteName: 'page1/page12/page121',
                          );
                      },
                              originUri: originUri,
                              path: destPath,
                              settings: settings)
                          .build(context);
                    default:
                      return SamplePage(
                        title: path1,
                      );
                  }
                },
                home: SamplePage(
                  title: path1,
                  nextRouteName: settings.name,
                ),
              ),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
                builder: (context) => Container(color: Colors.red));
        }
      },
      home: SamplePage(
        title: 'Home',
      ),
    );
  }
}

class SamplePage extends StatelessWidget {
  SamplePage({Key key, this.title, this.nextRouteName}) : super(key: key);

  final String title;
  final String nextRouteName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (nextRouteName != null)
            RaisedButton(
              color: Colors.pinkAccent,
              onPressed: () {
                Navigator.of(context).pushNamed(nextRouteName);
              },
              child: Text(
                'Next',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          if (title == 'Home') ...[
            RaisedButton(
              color: Colors.pinkAccent,
              onPressed: () {
                Navigator.of(context).pushNamed('page1/page11');
              },
              child: Text(
                'Next 1',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            RaisedButton(
              color: Colors.pinkAccent,
              onPressed: () {
                Navigator.of(context).pushNamed('page1/page12');
              },
              child: Text(
                'Next 2',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
          RaisedButton(
            color: Colors.black26,
            onPressed: () {
              navigatorPopWithParent(context);
            },
            child: Text(
              'Back',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
