import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_gesture_unfocus.dart';

@RoutePage()
class AdminTabsPage extends StatefulWidget {
  const AdminTabsPage({super.key});

  @override
  State<AdminTabsPage> createState() => _AdminTabsPageState();
}

class _AdminTabsPageState extends State<AdminTabsPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        AdminIncomeRoute(),
        AdminTransactionRoute(),
      ],
      builder: (context, child, controller) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                "Transaksi", style: context.textTheme.headlineLarge,
              ),
            ),
          ),
          body: CustomGestureUnfocus(
            child: Column(
              children: [
                _buildTabBar(controller, tabsRouter, context),
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }

  TabBar _buildTabBar(
      TabController controller,
      TabsRouter tabsRouter,
      BuildContext context,
      ) {
    return TabBar(
      controller: controller,
      onTap: (value) {
        setState(() {
          tabsRouter.setActiveIndex(value);
        });
      },
      tabs: [
        Tab(
          child: Text(
            "Pemasukan",
            style: tabsRouter.activeIndex == 0
                ? context.textTheme.bodyMediumBold
                : context.textTheme.bodyMediumBold.copyWith(
              color: ColorValues.grey30,
            ),
          ),
        ),
        Tab(
          child: Text(
            "Pengeluaran",
            style: tabsRouter.activeIndex == 1
                ? context.textTheme.bodyMediumBold
                : context.textTheme.bodyMediumBold.copyWith(
              color: ColorValues.grey30,
            ),
          ),
        ),
      ],
      indicatorColor: ColorValues.primary50,
    );
  }
}
