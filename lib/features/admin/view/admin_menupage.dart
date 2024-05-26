import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/routes/router.dart';

@RoutePage()
class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        AdminHomeRoute(),
        AdminCustomerRoute(),
        AdminTabsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: (index) async {
            if (index == 3) {
              await FirebaseAuth.instance.signOut();
              AutoRouter.of(context).pushAndPopUntil(LoginRoute(), predicate: (route) => false);
            } else {
              tabsRouter.setActiveIndex(index);
            }
          },
          destinations: [
            NavigationDestination(
              icon: Icon(IconsaxPlusBold.home_2),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(IconsaxPlusBold.profile_2user),
              label: 'Pengguna',
            ),
            NavigationDestination(
              icon: Icon(IconsaxPlusBold.receipt_text),
              label: 'Transaksi',
            ),
            NavigationDestination(
              icon: Icon(IconsaxPlusBold.logout),
              label: 'Keluar',
            ),
          ],
        );
      },
    );
  }
}
