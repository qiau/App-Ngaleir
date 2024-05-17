import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/models/auth.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/app_text_styles.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/utils/auth_utils.dart';
import 'package:perairan_ngale/widgets/custom_button.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential != null) {
        User? user = userCredential.user;
        if (user != null) {
          if (await isAdmin(user.uid)) {
            // AutoRouter.of(context).replace(());
            return;
          } else if (await isEmployee(user.uid)) {
            AutoRouter.of(context).replace(EmployeeHomeRoute());
            return;
          } else if (await isCustomer(user.uid)) {
              AutoRouter.of(context).replace(CustomerHomeRoute());
              return;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login gagal. Silakan coba lagi.")),
        );
      }
    } catch (error) {
      print("Error: $error");
    }
  }

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
            child: _buildLoginForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
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
                    "Masuk",
                    style: AppTextStyles.style(context).titleLarger,
                  ),
                  Text(
                    "Masukkan nomor telepon atau email untuk masuk ke akunmu!",
                    style: AppTextStyles.style(context).bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email",
                  style: AppTextStyles.style(context).titleSmall,
                ),
                SizedBox(height: 8.0),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Email",
                  fillColor: ColorValues.white,
                  prefixIcon: IconsaxPlusLinear.sms,
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
                    controller: _passwordController,
                    hintText: "Kata sandi",
                    fillColor: ColorValues.white,
                    prefixIcon: IconsaxPlusLinear.key,
                    obscureText: true,
                  ),
                ],
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              padding: const EdgeInsets.symmetric(),
              child: CustomButton(
                text: "Masuk",
                backgroundColor: ColorValues.primary50,
                textColor: ColorValues.white,
                width: double.infinity,
                onPressed: _login,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun? Yuk",
                    style: AppTextStyles.style(context).bodySmall,
                  ),
                  TextButton(
                    onPressed: () {
                      AutoRouter.of(context).replace(RegisterRoute());
                    },
                    child: Text("Daftar!"),
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
