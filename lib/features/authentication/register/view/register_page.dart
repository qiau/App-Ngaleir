import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:perairan_ngale/shared/app_text_styles.dart';

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
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 141.0),
              child: _buildRegisterForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
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
                  "Nomor telepon",
                  style: AppTextStyles.style(context).titleSmall,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.call_outlined),
                    hintText: "Nomor telepon atau Email",
                    hintStyle: AppTextStyles.style(context).bodySmallGrey,
                  ),
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
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.key_rounded),
                      hintText: "Kata sandi",
                      hintStyle: AppTextStyles.style(context).bodySmallGrey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 343,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Daftar"),
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
                    onPressed: () {},
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
