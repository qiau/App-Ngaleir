import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class AdminWithdrawalPage extends StatefulWidget {
  const AdminWithdrawalPage({super.key});

  @override
  State<AdminWithdrawalPage> createState() => _AdminWithdrawalPageState();
}

class _AdminWithdrawalPageState extends State<AdminWithdrawalPage> {
  final _saldoController = TextEditingController();
  final _deskripsiController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tarik Saldo',
          style: context.textTheme.titleMedium,
        ),
        backgroundColor: ColorValues.danger10,
      ),
      backgroundColor: ColorValues.danger10,
      body: Padding(
        padding: const EdgeInsets.only(top: Styles.defaultPadding),
        child: Container(
          width: double.infinity,
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(context),
              SizedBox(height: Styles.defaultPadding),
              _buildSaldoTextField(context),
              SizedBox(height: Styles.bigPadding),
              _buildDeskripsiTextField(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTitleSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Styles.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Catat Saldo Keluar", style: context.textTheme.bodyMediumBold),
          Text("Pastikan data yang dimasukkan sesuai",
              style: context.textTheme.bodySmallGrey),
        ],
      ),
    );
  }

  Padding _buildSaldoTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
      child: CustomTextField(
        controller: _saldoController,
        hintText: "Rp 0",
        label: "Jumlah Saldo",
        keyboardType: TextInputType.number,
      ),
    );
  }

  Padding _buildDeskripsiTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
      child: CustomTextField(
        hintText: "Tambahkan keterangan singkat...",
        label: "Keterangan",
        controller: _deskripsiController,
        maxLines: null,
      ),
    );
  }
}
