import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:perairan_ngale/features/customer/customer.dart';
import 'package:perairan_ngale/features/admin/admin.dart';
import 'package:perairan_ngale/features/authentication/authentication.dart';
import 'package:perairan_ngale/features/employee/employee.dart';
import 'package:perairan_ngale/models/customer.dart';
import 'package:perairan_ngale/home_wrapper.dart';

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
        CustomRoute(
          page: EmployeeHomeRoute.page,
          path: '/employee_homepage',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: LoginRoute.page,
          path: '/authentication_login-page',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: RegisterRoute.page,
          path: '/authentication_register-page',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: EmployeeAddCustomerRecordRoute.page,
          path: '/employee_add_record',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: HomeWrapperRoute.page,
          path: '/',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          initial: true,
        )
      ];
}
