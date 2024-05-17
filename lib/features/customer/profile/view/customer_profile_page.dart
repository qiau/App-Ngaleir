import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/app_text_styles.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';

@RoutePage()
class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: AppTextStyles.style(context).bodyMediumBold,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: ColorValues.grey90,
          ),
          onPressed: () {
            AutoRouter.of(context).maybePop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(Styles.defaultPadding),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: Styles.biggerPadding),
                child:
                Icon(IconsaxPlusBold.profile_circle, size: Styles.bigIcon, color: Colors.black),
              ),
              Container(
                child: Column(
                  children: [
                    customerIdentity(context, "Nama", "Pelanggan A"),
                    customerIdentity(context, "Nomor Pelanggan", "01238922"),
                    customerIdentity(context, "Nomor Telepon", "08975672384"),
                    customerIdentity(context, "Alamat", "Jl. Kenangan"),
                    customerIdentity(context, "RT", "01"),
                    customerIdentity(context, "RW", "07"),
                  ],
                ),
              ),
              Container(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorValues.danger60,
                    textStyle: AppTextStyles.style(context).bodyMediumBold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Styles.defaultBorder),
                      ),
                    ),
                    side: BorderSide(width: 1.5, color: ColorValues.danger60),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    AutoRouter.of(context).pushAndPopUntil(LoginRoute(), predicate: (route) => false);
                  },
                  child: Text('Keluar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customerIdentity(
      BuildContext context, String identity, String details) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              identity,
              style: AppTextStyles.style(context).bodyMediumBold,
              textAlign: TextAlign.left,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              details,
              style: AppTextStyles.style(context).bodyMedium,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
