import 'package:flutter/material.dart';

///return first path if condition is [path] is empty and [url].pathSegments is not empty.
///else return the path which is after [path] if exists.
String getPathAfter(String path, String url) {
  try {
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
  } catch (e) {
    debugPrint(e);
  }
  return null;
}

BuildContext findParentContext(BuildContext context) {
  assert(context != null);
  try {
    final parentState = context.findAncestorStateOfType<State<MaterialApp>>();
    return parentState?.context;
  } catch (e) {}
  return null;
}

bool navigatorPopWithParent(BuildContext context) {
  assert(context != null);
  try {
    var nav = Navigator.of(context);
    if (nav.canPop()) return nav.pop();
    final parentContext = findParentContext(context);
    if (parentContext != null) {
      nav = Navigator.of(parentContext);
      if (nav.canPop()) return nav.pop();
    }
  } catch (e) {}
  return false;
}

///[destPath] is the path after [rootPath], it is the destination path need to show.
typedef SubAppWidgetBuilder = Widget Function(Uri originUri, String destPath,
    RouteSettings settings, BuildContext context);

class SubApp extends MaterialApp {
  final Uri originUri;
  final String rootPath;
  SubApp({
    this.rootPath,
    this.originUri,
    ThemeData theme,
    Widget home,
    SubAppWidgetBuilder onGenerateRouteWidget,
    Widget page404,
  }) : super(
          theme: theme,
          onGenerateRoute: (settings) {
            final destPath = getPathAfter(rootPath, settings?.name);
            if (destPath == null || destPath.isEmpty) return null;
            return MaterialPageRoute(
              builder: (context) => onGenerateRouteWidget != null
                  ? (onGenerateRouteWidget(
                          originUri, destPath, settings, context) ??
                      page404 ??
                      Container(
                        color: Colors.white,
                      ))
                  : page404 ??
                      Container(
                        color: Colors.white,
                      ),
            );
          },
          home: home,
        );
}

///[destPath] is the path after [rootPath], it is the destination path need to show.
typedef SubRouteWidgetBuilder = Widget Function(Uri originUri, String rootPath,
    String destPath, RouteSettings settings, BuildContext context);

class SubRouteWidget {
  final Uri originUri;
  final String rootPath;
  final RouteSettings settings;
  final SubRouteWidgetBuilder builder;

  SubRouteWidget({
    this.builder,
    this.originUri,
    this.rootPath,
    this.settings,
  });

  Widget build(BuildContext context) {
    debugPrint('SubRouteWidgetBuilder.build: originUri=$originUri');
    debugPrint(
        'SubRouteWidgetBuilder.build: settings.arguments=${settings.arguments}');
    final destPath = getPathAfter(rootPath, settings?.name ?? originUri);
    return builder(originUri, rootPath, destPath, settings, context);
  }
}

class SubAppRouteSettingsArguments {
  final Uri originUri;
  final String rootPath;
  final dynamic arguments;

  SubAppRouteSettingsArguments({this.originUri, this.rootPath, this.arguments});
}
