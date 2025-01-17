import 'package:stacked/src/code_generation/router/parameters.dart';
import 'package:stacked/src/code_generation/router/route_matcher.dart';
import 'package:stacked/src/code_generation/router/router_base.dart';
import 'package:flutter/widgets.dart';

@immutable
class RouteData extends RouteSettings {
  RouteData(this.routeMatch)
      : _pathParams = routeMatch.pathParams,
        _queryParams = routeMatch.queryParams,
        fragment = routeMatch.uri.fragment,
        super(
          name: routeMatch.name,
          arguments: routeMatch.arguments is Map
              ? ((routeMatch.arguments as Map?)?['arguments'])
              : routeMatch.arguments,
        );

  final RouteMatch routeMatch;
  final Parameters _pathParams;
  final Parameters _queryParams;
  final String fragment;

  String get template => routeMatch.template;

  Parameters get queryParams => _queryParams;

  Parameters get pathParams => _pathParams;

  String get path => routeMatch.uri.path;

  Object? get _initialArgsToPass => routeMatch.initialArgsToPass;

  T getArgs<T>({bool nullOk = true, T Function()? orElse}) {
    if (nullOk == true) {
      assert(orElse != null);
    }
    if (_hasInvalidArgs<T>(nullOk)) {
      throw FlutterError(
          'Expected [${T.toString()}],  found [${arguments?.runtimeType}]');
    }
    return arguments as T? ?? orElse!();
  }

  bool _hasInvalidArgs<T>(bool nullOk) {
    if (!nullOk) {
      return (arguments is! T);
    } else {
      return (arguments != null && arguments is! T);
    }
  }

  @override
  String toString() {
    return 'RouteData{template: ${routeMatch.template}, '
        'path: ${routeMatch.path}, fullName: ${routeMatch.name}, args: $arguments,  params: $_pathParams, query: $_queryParams}';
  }

  static RouteData? of(BuildContext context) {
    var modal = ModalRoute.of(context);
    if (modal != null && modal.settings is RouteData) {
      return modal.settings as RouteData;
    } else {
      return null;
    }
  }

  static RoutePredicate withPath(String path) {
    return (Route<dynamic> route) {
      return !route.willHandlePopInternally &&
          route is ModalRoute &&
          route.settings is RouteData &&
          (route.settings as RouteData).template == path;
    };
  }
}

@immutable
class ParentRouteData<T extends RouterBase> extends RouteData {
  final Uri? initialRoute;
  final T? router;

  ParentRouteData({
    this.initialRoute,
    this.router,
    required RouteMatch matchResult,
  }) : super(matchResult);

  Object? get initialRouteArgs => _initialArgsToPass;
  static ParentRouteData? of(BuildContext context) {
    var modal = ModalRoute.of(context);
    if (modal != null && modal.settings is ParentRouteData) {
      return modal.settings as ParentRouteData;
    } else {
      return null;
    }
  }
}
