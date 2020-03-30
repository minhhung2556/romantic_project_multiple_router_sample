import 'package:flutter/material.dart';

///return first path if condition is [path] is empty and [url].pathSegments is not empty.
///else return the path which is after [path] if exists.
String getPathAfter(String path, String url) {
  debugPrint('getPathAfter: url=$url');
  final uri = Uri.tryParse(url);
  debugPrint('getPathAfter: uri=$uri');
  if (uri?.pathSegments != null && uri?.pathSegments?.isNotEmpty == true) {
    var destPath;
    if (path == null || path.isEmpty)
      destPath = uri.pathSegments.first;
    else {
      var i = uri.pathSegments.indexOf(path);
      if (i > -1 && i + 1 < uri.pathSegments.length)
        destPath = uri.pathSegments[i + 1];
    }
    debugPrint('getPathAfter: path=$destPath');
    return destPath;
  }
  debugPrint('getPathAfter: empty path');
  return null;
}

bool navigatorPopWithParent(BuildContext context, BuildContext parentContext) {
  assert(context != null);
  var nav = Navigator.of(context);
  if (nav.canPop()) return nav.pop();
  if (parentContext != null) {
    nav = Navigator.of(parentContext);
    if (nav.canPop()) return nav.pop();
  }
  return false;
}

class SubApp extends MaterialApp {
  final BuildContext parentContext;
  final String appPath;

  SubApp({
    this.parentContext,
    this.appPath,
    ThemeData theme,
    Widget home,

    ///[destPath] is the path after appPath, it is the destination path need to show.
    Widget Function(
            BuildContext parentContext, RouteSettings settings, String destPath)
        onGenerateRouteWidget,
  }) : super(
          theme: theme,
          onGenerateRoute: (settings) {
            final destPath = getPathAfter(appPath, settings?.name);
            return MaterialPageRoute(
                builder: (context) => onGenerateRouteWidget != null &&
                        destPath != null
                    ? onGenerateRouteWidget(parentContext, settings, destPath)
                    : Container(
                        color: Colors.white,
                      ));
          },
          home: home,
        );
}
