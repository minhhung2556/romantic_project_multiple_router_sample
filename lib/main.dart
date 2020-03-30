import 'package:flutter/material.dart';

void main() => runApp(MyApp());

String getPathAt(String url, [int index = 0]) {
  debugPrint('url: $url');
  final uri = Uri.tryParse(url);
  debugPrint('uri: $uri');
  final path =
      (uri?.pathSegments?.length ?? 0) > index ? uri.pathSegments[index] : '';
  debugPrint('path at $index: $path');
  return path;
}

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
        final path1 = getPathAt(url, 0);
        switch (path1) {
          case 'page1':
            return MaterialPageRoute(
              builder: (parentContext) => MaterialApp(
                theme: ThemeData(
                  primarySwatch: Colors.amber,
                ),
                onGenerateRoute: (settings) {
                  final url = settings.name;
                  final path11 = getPathAt(url, 1);
                  switch (path11) {
                    case 'page11':
                      return MaterialPageRoute(
                          builder: (context) => SamplePage(
                                title: path11,
                                parentContext: parentContext,
                              ));
                    default:
                      return MaterialPageRoute(
                          builder: (context) => Container(color: Colors.red));
                  }
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
        nextRouteName: 'page1',
      ),
    );
  }
}

class SamplePage extends StatefulWidget {
  SamplePage({Key key, this.title, this.nextRouteName, this.parentContext})
      : super(key: key);

  final BuildContext parentContext;
  final String title;
  final String nextRouteName;

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (widget.nextRouteName != null)
            RaisedButton(
              color: Colors.pinkAccent,
              onPressed: () {
                Navigator.of(context).pushNamed(widget.nextRouteName);
              },
              child: Text(
                'Next',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          RaisedButton(
            color: Colors.black26,
            onPressed: () {
              final navi = Navigator.of(context);
              if (navi.canPop())
                navi.pop();
              else if (widget.parentContext != null)
                Navigator.of(widget.parentContext).pop();
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
