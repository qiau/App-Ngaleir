import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/features/authentication/authentication.dart';
import 'package:perairan_ngale/features/authentication/login/view/login_page.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/app_text_styles.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/widgets/custom_button.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: svg.Svg('assets/bg_loginregis.svg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 140.0),
            child: _buildRegisterForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daftar",
                    style: AppTextStyles.style(context).titleLarger,
                  ),
                  Text(
                    "Masukkan nomor telepon atau email, dan buat password untuk mendaftar!",
                    style: AppTextStyles.style(context).bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nomor telepon",
                  style: AppTextStyles.style(context).titleSmall,
                ),
                SizedBox(height: 8.0),
                CustomTextField(
                  controller: TextEditingController(),
                  hintText: "Nomor telepon atau Email",
                  fillColor: ColorValues.white,
                  prefixIcon: IconsaxPlusLinear.call,
                  onChanged: (s) {},
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kata sandi",
                    style: AppTextStyles.style(context).titleSmall,
                  ),
                  SizedBox(height: 8.0),
                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: "Kata sandi",
                    fillColor: ColorValues.white,
                    prefixIcon: IconsaxPlusLinear.key,
                    obscureText: true,
                    onChanged: (s) {},
                  ),
                ],
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              padding: const EdgeInsets.symmetric(),
              child: CustomButton(
                text: "Daftar",
                backgroundColor: ColorValues.primary50,
                textColor: ColorValues.white,
                width: double.infinity,
                onPressed: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? Yuk",
                    style: AppTextStyles.style(context).bodySmall,
                  ),
                  TextButton(
                    onPressed: () {
                      AutoRouter.of(context).replace(LoginRoute());
                    },
                    child: Text("Masuk!"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
