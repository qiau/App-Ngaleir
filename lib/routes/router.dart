import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:perairan_ngale/features/home/homepage.dart';
import  'package:perairan_ngale/features/bill/billpage.dart';

part 'router.gr.dart';

// generate with dart run build_runner build
@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: HomeRoute.page,
          path: '/',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 700,
          initial: true,
        ),
        CustomRoute(
          page: BillRoute.page,
          path: '/billpage',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 700,
        ),
      ];
}
