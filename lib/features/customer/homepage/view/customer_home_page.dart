import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';

@RoutePage()
class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValues.grey10,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBarWidget(),
            const SizedBox(
              height: Styles.biggerSpacing,
            ),
            _buildRecordsWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.71, -0.71),
          end: Alignment(-0.71, 0.71),
          colors: [Colors.blue, Colors.lightBlue],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Styles.defaultBorder),
          bottomRight: Radius.circular(Styles.defaultBorder),
        ),
      ),
      child: Stack(
        children: [
          _buildTopBarContentWidget(),
        ],
      ),
    );
  }

  Widget _buildTopBarContentWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Styles.defaultPadding),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Styles.defaultPadding),
              child: Icon(
                IconsaxPlusLinear.profile_circle,
                size: Styles.bigIcon,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nama Pelanggan",
                    style: context.textTheme.bodyMediumBoldBright,
                  ),
                  const SizedBox(
                    height: Styles.smallSpacing,
                  ),
                  Text(
                    "Nomor Pelangggan",
                    style: context.textTheme.bodySmallBright,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                IconsaxPlusLinear.setting,
                size: Styles.bigIcon,
                color: Colors.white,
              ),
              onPressed: () {
                AutoRouter.of(context).push(CustomerProfileRoute());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: ColorValues.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Styles.defaultBorder),
          topRight: Radius.circular(Styles.defaultBorder),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Styles.defaultPadding),
        child: Column(
          children: [
            Center(
              child: Text(
                "Riwayat Pencatatan",
                style: context.textTheme.bodyMediumBold,
              ),
            ),
            _buildHistoryWidget(),
            _buildHistoryWidget(),
            _buildHistoryWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryWidget() {
    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(CustomerRecordDetailRoute());
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Styles.smallerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Mei 2024",
                  style: context.textTheme.bodyMediumBold,
                ),
              ),
              _buildHistoryItemWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItemWidget() {
    return Container(
      decoration: BoxDecoration(
        color: ColorValues.white,
        borderRadius: BorderRadius.circular(Styles.defaultBorder),
        border: Border.all(
          color: ColorValues.grey30,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Styles.defaultPadding),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Styles.defaultPadding),
              child: Icon(
                IconsaxPlusLinear.shopping_cart,
                size: Styles.bigIcon,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nama Pelanggan",
                    style: context.textTheme.bodyMediumBold,
                  ),
                  const SizedBox(
                    height: Styles.smallSpacing,
                  ),
                  Text(
                    "24/04/2024 13:00",
                    style: context.textTheme.bodySmallGrey,
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Icon(
                IconsaxPlusLinear.arrow_right_3,
                size: Styles.defaultIcon,
              ),
              onTap: () {
                AutoRouter.of(context).push(CustomerProfileRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}
