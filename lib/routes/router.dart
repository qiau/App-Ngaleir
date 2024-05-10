import 'package:auto_route/auto_route.dart';
import 'package:perairan_ngale/features/customer/customer.dart';
import 'package:perairan_ngale/features/admin/admin.dart';
import 'package:perairan_ngale/features/authentication/authentication.dart';
import 'package:perairan_ngale/features/employee/employee.dart';


part 'router.gr.dart';

// generate with dart run build_runner build
@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: CustomerFormRoute.page,
          path: '/customer_list-form',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: CustomerHomeRoute.page,
          path: '/customer_list-homepage',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: CustomerProfileRoute.page,
          path: '/customer_list-profile',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: CustomerRecordDetailRoute.page,
          path: '/customer_list-record-detail',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
      ];
}
