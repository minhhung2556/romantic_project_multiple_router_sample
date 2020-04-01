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
typedef SubAppWidgetBuilder = Widget Function(String originUri, String destPath,
    RouteSettings settings, BuildContext context);

class SubApp extends MaterialApp {
  final Map<String, SubRouteWidgetBuilder> subRouteWidgetBuilders;

  SubApp({
    ThemeData theme,
    Widget home,
    Widget page404,
    Key key,
    String rootPath,
    this.subRouteWidgetBuilders,
  }) : super(
          key: key,
          theme: theme,
          onGenerateRoute: (settings) {
            String originUri;
            if (settings.arguments is Map<String, dynamic>) {
              final map = settings.arguments as Map<String, dynamic>;
              originUri = map['originUri']?.toString();
            }

            final destPath = getPathAfter(rootPath, settings?.name);
            if (destPath == null || destPath.isEmpty) return null;

            return MaterialPageRoute(
              builder: (context) {
                Widget widget;
                if (subRouteWidgetBuilders != null) {
                  final childDestPath =
                      getPathAfter(destPath, originUri ?? settings?.name);
                  debugPrint(
                      'SubRouteWidgetBuilder.build: rootPath=$rootPath, destPath=$destPath, childDestPath=$childDestPath');

                  if (subRouteWidgetBuilders[destPath] != null) {
                    widget = subRouteWidgetBuilders[destPath](
                        originUri, destPath, childDestPath, settings, context);
                  }
                }
                widget = widget ?? page404 ?? Container(color: Colors.white);
                return widget;
              },
            );
          },
          home: home,
        );
}

///[destPath] is the path after [rootPath], it is the destination path need to show.
typedef SubRouteWidgetBuilder = Widget Function(
    String originUri,
    String rootPath,
    String destPath,
    RouteSettings settings,
    BuildContext context);

class SubRouteWidget {
  final String rootPath;
  final RouteSettings settings;
  final SubRouteWidgetBuilder builder;

  SubRouteWidget({
    this.builder,
    this.rootPath,
    this.settings,
  });

  Widget build(BuildContext context) {
    String originUri;
    dynamic data;
    if (settings.arguments is Map<String, dynamic>) {
      final map = settings.arguments as Map<String, dynamic>;
      originUri = map['originUri']?.toString();
      data = map['data'];
    }

    debugPrint('SubRouteWidgetBuilder.build: data=$data');
    final destPath = getPathAfter(rootPath, originUri ?? settings?.name);
    debugPrint(
        'SubRouteWidgetBuilder.build: rootPath=$rootPath, destPath=$destPath');
    return builder(originUri, rootPath, destPath, settings, context);
  }
}
