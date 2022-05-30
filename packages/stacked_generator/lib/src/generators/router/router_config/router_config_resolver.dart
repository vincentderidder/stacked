import 'package:analyzer/dart/constant/value.dart';
import 'package:stacked_generator/import_resolver.dart';
import 'package:stacked_generator/route_config_resolver.dart';
import 'package:source_gen/source_gen.dart';

import 'router_config.dart';

class RouterConfigResolver {
  final ImportResolver _importResolver;

  RouterConfigResolver(this._importResolver);

  Future<RouterConfig> resolve(ConstantReader stackedApp) async {
    final generateNavigationExt =
        stackedApp.peek('generateNavigationHelperExtension')?.boolValue ??
            false;
    final routeNamePrefix = stackedApp.peek('routePrefix')?.stringValue ?? '/';
    final routesClassName =
        stackedApp.peek('routesClassName')?.stringValue ?? 'Routes';

    final nestedRoutes = stackedApp.read('routes').listValue;

    var routerConfig = RouterConfig(
      routerClassName: 'StackedRouter',
      routesClassName: routesClassName,
      routeNamePrefix: routeNamePrefix,
      generateNavigationHelper: generateNavigationExt,
    );

    final routes = await _resolveRoutes(routerConfig, nestedRoutes);
    return routerConfig.copyWith(routes: routes);
  }

  Future<List<RouteConfig>> _resolveRoutes(
    RouterConfig routerConfig,
    List<DartObject> routesList,
  ) async {
    final List<RouteConfig> allRoutes = [];

    for (var routeDartObject in routesList) {
      final routeReader = ConstantReader(routeDartObject);
      var route = await RouteConfigResolver(
              routerConfig.routeNamePrefix, _importResolver)
          .resolve(routeReader);

      final children = routeReader.peek('children')?.listValue;

      if (children?.isNotEmpty ?? false) {
        final childrenRoutes = await _resolveRoutes(routerConfig, children!);
        route = route.copyWith(children: childrenRoutes);
      }
      allRoutes.add(route);
    }
    return allRoutes;
  }
}
