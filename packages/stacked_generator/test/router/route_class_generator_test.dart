import 'package:stacked_generator/route_config_resolver.dart';
import 'package:stacked_generator/src/generators/exceptions/invalid_generator_input_exception.dart';
import 'package:stacked_generator/src/generators/router/generator/router_class_generator.dart';
import 'package:stacked_generator/src/generators/router/route_config/adaptive_route_config.dart';
import 'package:stacked_generator/src/generators/router/route_config/cupertino_route_config.dart';
import 'package:stacked_generator/src/generators/router/route_config/custom_route_config.dart';
import 'package:stacked_generator/src/generators/router/route_config/material_route_config.dart';
import 'package:stacked_generator/src/generators/router/router_config/router_config.dart';
import 'package:test/test.dart';

import '../helpers/router_constants.dart';

void main() {
  group('RouteClassGeneratorTest -', () {
    void generateRoutesAndExpectException<T>(List<RouteConfig> routes,
        [String? exceptionMessage]) {
      final routerBaseGenerator = RouterClassGenerator(RouterConfig(
          routesClassName: 'RoutesTestClassName',
          routerClassName: 'RouterTestClassName',
          routes: routes));
      expect(
        () => routerBaseGenerator.generate(),
        throwsA(predicate<dynamic>((e) => e is T && exceptionMessage == null
            ? true
            : e.message == exceptionMessage)),
      );
    }

    void generateRouteAndExpectResult(
        List<RouteConfig> routes, dynamic expectedResult,
        {bool verbose = false}) {
      final routerBaseGenerator = RouterClassGenerator(RouterConfig(
          routesClassName: 'RoutesTestClassName',
          routerClassName: 'RouterTestClassName',
          generateNavigationHelper: true,
          routes: routes));
      if (verbose) print(routerBaseGenerator.generate());
      expect(routerBaseGenerator.generate(), expectedResult);
    }

    group('RouteType.material - default -', () {
      test('When routes are empty', () {
        List<RouteConfig> routes = [];

        generateRouteAndExpectResult(
          routes,
          kRouterWithEmptyRoutes,
        );
      });

      test('Given the following RouteConfig, Generate output', () {
        final routes = [
          MaterialRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
          )
        ];

        generateRouteAndExpectResult(routes, kRouterWithNamePathNameClassName);
      });
      test('Given the following three RouteConfig, Generate output', () {
        final routes = [
          MaterialRouteConfig(
            name: 'loginView1',
            pathName: 'pathNamaw1',
            className: 'TestClass1',
          ),
          MaterialRouteConfig(
            name: 'loginView2',
            pathName: 'pathNamaw2',
            className: 'TestClass2',
          ),
          MaterialRouteConfig(
            name: 'loginView3',
            pathName: 'pathNamaw3',
            className: 'TestClass3',
          ),
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterWithThreeNamePathNameClassName,
        );
      });

      test('When fullscreenDialog is true', () {
        final routes = [
          MaterialRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
            fullscreenDialog: true,
          )
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithNamePathNameClassNameFullScreenDialogIsTrue);
      });
      test(
          'When fullscreenDialog is false, Should add nothing cause it is default',
          () {
        final routes = [
          MaterialRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
            fullscreenDialog: false,
          )
        ];

        generateRouteAndExpectResult(routes, kRouterWithNamePathNameClassName);
      });
      test('When adding one RouteGuardConfig', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              guards: [
                RouteGuardConfig(import: 'guard/import.dart', type: 'GuardType')
              ])
        ];

        generateRouteAndExpectResult(routes, kRouterWithOneGuard);
      });
      test('When adding two RouteGuardConfig', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              guards: [
                RouteGuardConfig(
                  import: 'guard/import.dart',
                  type: 'GuardType',
                ),
                RouteGuardConfig(
                  import: 'guard/import2.dart',
                  type: 'GuardType2?',
                ),
              ])
        ];

        generateRouteAndExpectResult(routes, kRouterWithTwoGuards);
      });
      test('When hasConstConstructor is false have no effect ', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              hasConstConstructor: false)
        ];

        generateRouteAndExpectResult(routes, kRouterWithNamePathNameClassName);
      });
      test('When hasConstConstructor is true', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              hasConstConstructor: true)
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithHasConstConstructorIsTrue);
      });
      test('When hasWrapper is false have no effect ', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              hasWrapper: false)
        ];

        generateRouteAndExpectResult(routes, kRouterWithNamePathNameClassName);
      });
      test('When hasConstConstructor is true', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              hasWrapper: true)
        ];

        generateRouteAndExpectResult(routes, kRouterWithHasWrapperIsTrue);
      });
      test('When has two imports', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              imports: {'import one', 'import two'})
        ];
        generateRouteAndExpectResult(routes, kRouterWithImports);
      });
      test('When maintainstate is true, Should add nothing cause it is default',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              maintainState: true)
        ];
        generateRouteAndExpectResult(routes, kRouterWithNamePathNameClassName);
      });
      test('When maintainstate is false', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              maintainState: false)
        ];
        generateRouteAndExpectResult(routes, kRouterWithMaintainStateIsFalse);
      });
      test(
          'When adding an empty parameter, SHould throw InvalidGeneratorInputException ',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [RouteParamConfig()])
        ];
        generateRoutesAndExpectException<InvalidGeneratorInputException>(routes,
            ExceptionMessages.isPathParamAndIsQueryParamShouldNotBeNull);
      });
      test('When adding a parameter with PathParam: false, isQueryParam: false',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(isPathParam: false, isQueryParam: false)
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryFalse);
      });
      test('When adding a parameter with PathParam: true, isQueryParam: false',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(isPathParam: true, isQueryParam: false)
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathTrueQueryFalse);
      });
      test('When adding a parameter with PathParam: true, isQueryParam: true',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(isPathParam: true, isQueryParam: true)
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathTrueQueryFalse);
      });
      test('When adding a parameter with PathParam: false, isQueryParam: true',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(isPathParam: false, isQueryParam: true)
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryTrue);
      });
      test(
          'When adding a parameter with PathParam: false, isQueryParam: true, alias: aliaso',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(
                    isPathParam: false, isQueryParam: true, alias: 'aliaso')
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryTrueAlias);
      });
      test(
          'When adding a parameter with PathParam: false, isQueryParam: true, defaultValueCode: 2',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(
                    isPathParam: false,
                    isQueryParam: true,
                    defaultValueCode: '2')
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryTrueDefaultCode2);
      });
      test(
          'When adding a parameter with PathParam: false, isQueryParam: true, imports',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(
                    isPathParam: false,
                    isQueryParam: true,
                    imports: {'parameter/import1', 'parameter/import2'})
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryTrueImports);
      });
      test(
          'When adding a parameter with PathParam: false, isQueryParam: true, isPositional: true',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(
                  isPathParam: false,
                  isQueryParam: true,
                  isPositional: true,
                )
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryTrueIsPositionalTrue);
      });
      test(
          'When adding a parameter with PathParam: false, isQueryParam: true, isRequired: true',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(
                  isPathParam: false,
                  isQueryParam: true,
                  isRequired: true,
                )
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryTrueIsRequiredTrue);
      });
      test(
          'When adding a parameter with PathParam: false, isQueryParam: true, isRequired: true,name: ebra',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(
                  isPathParam: false,
                  isQueryParam: true,
                  name: 'ebra',
                )
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryTrueIsRequiredTrueName);
      });
      test(
          'When adding a parameter with PathParam: false, isQueryParam: false, type: newType',
          () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              parameters: [
                RouteParamConfig(
                  isPathParam: false,
                  isQueryParam: false,
                  type: 'newType',
                )
              ])
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithParameterPathFalseQueryFalseType);
      });
      test('When adding returnType = returnYpe', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              returnType: 'returnYpe')
        ];

        generateRouteAndExpectResult(routes, kRouterWithRetrunType);
      });
      test('When adding returnType = <CupertinoRoute>', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              returnType: '<CupertinoRoute>')
        ];

        generateRouteAndExpectResult(
            routes, kRouterWithRetrunTypeCupertinoRoute);
      });
      test('When adding NestedRouter with one child', () {
        final routes = [
          MaterialRouteConfig(
            name: 'loginView1',
            pathName: 'pathNamaw1',
            className: 'TestClass1',
            returnType: 'returnYpe1',
            children: [
              MaterialRouteConfig(
                name: 'nestedView1',
                pathName: 'nestedPath1',
                className: 'nestedClass1',
              )
            ],
          )
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterWithNestedRouter,
        );
      });
      test('When adding multiple NestedRouter with one child each', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView1',
              pathName: 'pathNamaw1',
              className: 'TestClass1',
              returnType: 'returnYpe1',
              children: [
                MaterialRouteConfig(
                    name: 'nestedView1',
                    pathName: 'nestedPath1',
                    className: 'nestedClass1',
                    children: [
                      MaterialRouteConfig(
                        name: 'multiNestedmultiNestedView1',
                        pathName: 'multiNestedmultiNestedPath1',
                        className: 'multiNestedmultiNestedClass1',
                      )
                    ])
              ])
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterWithMultipleNestedRouter,
        );
      });
      test('When adding NestedRouter with three different childs', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView2',
              pathName: 'pathNamaw2',
              className: 'TestClass2',
              returnType: 'returnYpe2',
              children: [
                MaterialRouteConfig(
                  name: 'firstView',
                  pathName: 'firstPath',
                  className: 'firstClass',
                ),
                CupertinoRouteConfig(
                  name: 'secondView',
                  pathName: 'secondPath',
                  className: 'secondClass',
                ),
                CustomRouteConfig(
                  name: 'thirdView',
                  pathName: 'thirdPath',
                  className: 'thirdClass',
                ),
              ])
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterWithThreeNestedRouter,
        );
      });
      test('When adding NestedRouter with six different childs', () {
        final routes = [
          MaterialRouteConfig(
              name: 'loginView3',
              pathName: 'pathNamaw3',
              className: 'TestClass3',
              returnType: 'returnYpe3',
              children: [
                MaterialRouteConfig(
                  name: 'firstView',
                  pathName: 'firstPath',
                  className: 'firstClass',
                ),
                CupertinoRouteConfig(
                  name: 'secondView',
                  pathName: 'secondPath',
                  className: 'secondClass',
                ),
                AdaptiveRouteConfig(
                  name: 'thirdView',
                  pathName: 'thirdPath',
                  className: 'thirdClass',
                ),
              ]),
          AdaptiveRouteConfig(
              name: 'loginView4',
              pathName: 'pathNamaw4',
              className: 'TestClass4',
              returnType: 'returnYpe4',
              children: [
                MaterialRouteConfig(
                  name: 'fourthView',
                  pathName: 'fourthPath',
                  className: 'fourthClass',
                ),
                CupertinoRouteConfig(
                  name: 'fifthView',
                  pathName: 'fifthPath',
                  className: 'fifthClass',
                ),
                CustomRouteConfig(
                  name: 'sixthView',
                  pathName: 'sixthPath',
                  className: 'sixthClass',
                ),
              ]),
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterWithSixNestedRouter,
        );
      });
    });
    group('RouteType.cupertino -', () {
      test('Given the following RouteConfig, Generate output', () {
        final routes = [
          CupertinoRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
          )
        ];

        generateRouteAndExpectResult(
            routes, kRouterTypeCupertinoWithNamePathNameClassName);
      });
      test('With cupertinoNavTitle', () {
        final routes = [
          CupertinoRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              cupertinoNavTitle: 'cupertinoNavTitle')
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCupertinoWithCupertinoNavTitle,
        );
      });
    });
    group('RouteType.cupertino -', () {
      test('Given the following RouteConfig, Generate output', () {
        final routes = [
          CupertinoRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
          )
        ];

        generateRouteAndExpectResult(
            routes, kRouterTypeCupertinoWithNamePathNameClassName);
      });
      test('With cupertinoNavTitle', () {
        final routes = [
          CupertinoRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              cupertinoNavTitle: 'cupertinoNavTitle')
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCupertinoWithCupertinoNavTitle,
        );
      });
      test('With parameters path = false, query = false', () {
        final routes = [
          CupertinoRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
            parameters: [
              RouteParamConfig(
                isPathParam: false,
                isQueryParam: false,
              ),
            ],
          )
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCupertinoWithParametersPathFalseQueryFalse,
        );
      });
    });
    group('RouteType.adaptive -', () {
      test('Given the following RouteConfig, Generate output', () {
        final routes = [
          AdaptiveRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
          )
        ];

        generateRouteAndExpectResult(routes, kRouterTypeAdaptive);
      });
      test('With cupertinoNavTitle', () {
        final routes = [
          AdaptiveRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              cupertinoNavTitle: 'cupertinooo')
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeAdaptiveWithCupertinoNavTitle,
        );
      });
      test('With parameters path = false, query = false', () {
        final routes = [
          AdaptiveRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
            parameters: [
              RouteParamConfig(
                isPathParam: false,
                isQueryParam: false,
              ),
            ],
          )
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeAdaptiveWithParametersPathFalseQueryFalse,
        );
      });
    });
    group('RouteType.custom -', () {
      test('Given the following RouteConfig, Generate output', () {
        final routes = [
          CustomRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
          )
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCustom,
        );
      });

      test('With customRouteBarrierDismissible', () {
        final routes = [
          CustomRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              customRouteBarrierDismissible: false)
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCustomWithbarrierDismissible,
        );
      });
      test('With durationInMilliseconds', () {
        final routes = [
          CustomRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              durationInMilliseconds: 22)
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCustomWithTransitionDuration,
        );
      });
      test('With reverseDurationInMilliseconds', () {
        final routes = [
          CustomRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              reverseDurationInMilliseconds: 2)
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCustomWithReverseDurationInMilliseconds,
        );
      });
      test(
          'With customRouteOpaque true, Should add nothing cause it is default',
          () {
        final routes = [
          CustomRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              customRouteOpaque: true)
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCustom,
        );
      });
      test('With customRouteOpaque false', () {
        final routes = [
          CustomRouteConfig(
              name: 'loginView',
              pathName: 'pathNamaw',
              className: 'TestClass',
              customRouteOpaque: false)
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCustomWithCustomRouteOpaqueFalse,
        );
      });
      test('With parameters path = false, query = false', () {
        final routes = [
          CustomRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
            parameters: [
              RouteParamConfig(
                isPathParam: false,
                isQueryParam: false,
              ),
            ],
          )
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCustomWithParametersPathFalseQueryFalse,
        );
      });
      test('With parameters path = false, query = true', () {
        final routes = [
          CustomRouteConfig(
            name: 'loginView',
            pathName: 'pathNamaw',
            className: 'TestClass',
            parameters: [
              RouteParamConfig(
                isPathParam: false,
                isQueryParam: true,
              ),
            ],
          )
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterTypeCustomWithParametersPathFalseQueryTrue,
        );
      });
    });
    group('Mixed -', () {
      test('Given random routing system', () {
        final routes = [
          CustomRouteConfig(
            name: 'loginView1',
            pathName: 'pathNamaw1',
            className: 'TestClass1',
            reverseDurationInMilliseconds: 2,
            durationInMilliseconds: 22,
          ),
          MaterialRouteConfig(
              name: 'loginView2',
              pathName: 'pathNamaw2',
              className: 'TestClass2',
              parameters: [
                RouteParamConfig(
                  isPathParam: false,
                  isQueryParam: true,
                ),
              ]),
          MaterialRouteConfig(
              name: 'loginView3',
              pathName: 'pathNamaw3',
              className: 'TestClass3',
              parameters: [
                RouteParamConfig(
                  isPathParam: false,
                  isQueryParam: false,
                ),
              ]),
          MaterialRouteConfig(
              name: 'loginView4',
              pathName: 'pathNamaw4',
              className: 'TestClass4',
              maintainState: false),
          AdaptiveRouteConfig(
              name: 'loginView5',
              pathName: 'pathNamaw5',
              className: 'TestClass5',
              cupertinoNavTitle: 'cupertinooo'),
          CupertinoRouteConfig(
            name: 'loginView6',
            pathName: 'pathNamaw6',
            className: 'TestClass6',
          ),
        ];

        generateRouteAndExpectResult(
          routes,
          kRouterMixin,
        );
      });
    });
  });
}
