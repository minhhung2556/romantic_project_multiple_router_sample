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
              builder: (parentContext) => SubApp(
                theme: ThemeData(
                  primarySwatch: Colors.amber,
                ),
                appPath: path1,
                onGenerateRouteWidget: (parentContext, settings, destPath) {
                  return SamplePage(
                    title: destPath,
                    parentContext: parentContext,
                  );
                },
                home: SamplePage(
                  title: path1,
                  nextRouteName: 'page1/page11',
                  parentContext: parentContext,
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
        nextRouteName: 'page1/page11',
      ),
    );
  }
}

class SamplePage extends StatelessWidget {
  SamplePage({Key key, this.title, this.nextRouteName, this.parentContext})
      : super(key: key);

  final BuildContext parentContext;
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
          RaisedButton(
            color: Colors.black26,
            onPressed: () {
              navigatorPopWithParent(context, parentContext);
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
