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

bool navigatorPopWithParent(BuildContext context) {
  assert(context != null);
  try {
    final parentState = context.findAncestorStateOfType<State<MaterialApp>>();
    var nav = Navigator.of(context);
    if (nav.canPop()) return nav.pop();
    if (parentState?.context != null) {
      nav = Navigator.of(parentState?.context);
      if (nav.canPop()) return nav.pop();
    }
  } catch (e) {}
  return false;
}

class SubApp extends MaterialApp {
  final Uri originUri;
  final String appPath;

  SubApp({
    this.originUri,
    this.appPath,
    ThemeData theme,
    Widget home,

    ///[destPath] is the path after appPath, it is the destination path need to show.
    Widget Function(Uri originUri, String destPath, RouteSettings settings)
        onGenerateRouteWidget,
  }) : super(
          theme: theme,
          onGenerateRoute: (settings) {
            final destPath = getPathAfter(appPath, settings?.name);
            return MaterialPageRoute(
                builder: (context) =>
                    onGenerateRouteWidget != null && destPath != null
                        ? onGenerateRouteWidget(originUri, destPath, settings)
                        : Container(
                            color: Colors.white,
                          ));
          },
          home: home,
        );
}

class SubRouteWidgetBuilder {
  final Uri originUri;
  final String path;
  final RouteSettings settings;
  final Widget Function(SubRouteWidgetBuilder builder, String destPath)
      _onGenerateRouteWidget;

  SubRouteWidgetBuilder(
    this._onGenerateRouteWidget, {
    this.originUri,
    this.path,
    this.settings,
  });

  Widget build(BuildContext context) {
    final destPath = getPathAfter(path, settings?.name ?? originUri);
    debugPrint('SubRouteWidgetBuilder.build: originUri=$originUri');
    return _onGenerateRouteWidget(this, destPath);
  }
}
