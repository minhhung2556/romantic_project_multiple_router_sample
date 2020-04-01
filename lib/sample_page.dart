import 'package:flutter/material.dart';

import 'sub_app.dart';

class SamplePage extends StatelessWidget {
  SamplePage({Key key, this.title, this.nextRouteNames}) : super(key: key);

  final String title;
  final List<String> nextRouteNames;

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
          if (nextRouteNames != null && nextRouteNames.isNotEmpty)
            ...nextRouteNames.map((nn) => RaisedButton(
                  color: Colors.pinkAccent,
                  onPressed: () {
                    Navigator.of(context).pushNamed(nn, arguments: {
                      'originUri': nn,
                      'data': {'abc': '123'}
                    });
                  },
                  child: Text(
                    'Next $nn',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )),
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
