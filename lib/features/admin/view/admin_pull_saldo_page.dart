import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perairan_ngale/models/transaksi.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_button.dart';
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

  Future<void> _tarikSaldo(BuildContext context) async {
    try {
      final transaksi = Transaksi(
        deskripsi: _deskripsiController.text,
        saldo: int.parse(_saldoController.text),
        status: 'pengeluaran',
        tanggal: Timestamp.now().toDate().toString(),
        userId: FirebaseAuth.instance.currentUser!.uid,
      );

      await FirebaseFirestore.instance
          .collection('Transaksi')
          .add(transaksi.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarik saldo berhasil')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

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
              SizedBox(height: Styles.defaultPadding),
              _buildDeskripsiTextField(context),
              SizedBox(height: Styles.bigPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Styles.defaultPadding),
                child: CustomButton(
                  onPressed: () {
                    _tarikSaldo(context);
                    AutoRouter.of(context).pushAndPopUntil(HomeWrapperRoute(),
                        predicate: (route) => false);
                  },
                  text: 'Tarik Saldo',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  width: double.infinity,
                ),
              ),
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
