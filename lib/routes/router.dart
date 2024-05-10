import 'package:auto_route/auto_route.dart';

part 'router.gr.dart';

// generate with dart run build_runner build
@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: CustomerFormRoute.page,
          path: '/customer-form',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: CustomerHomepage.page,
          path: '/customer-homepage',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: CustomerProfileRoute.page,
          path: '/customer-profile',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: CustomerRecordDetailRoute.page,
          path: '/customer-record-detail',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
      ];
}
