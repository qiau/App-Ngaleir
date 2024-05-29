// ignore_for_file: unused_import

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/models/customer.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_button.dart';
import 'package:perairan_ngale/widgets/custom_gesture_unfocus.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class CustomerFormPage extends StatefulWidget {
  const CustomerFormPage({super.key});

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _noTelponController = TextEditingController();
  final TextEditingController _towerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          title: Padding(
            padding: EdgeInsets.only(left: Styles.smallerPadding),
            child: Center(
              child: Text(
                'Silakan isi data diri Anda',
                style: context.textTheme.titleLarge,
              ),
            ),
          ),
        ),
        body: CustomGestureUnfocus(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
              child: Column(
                children: [
                  _buildNameField(),
                  _buildNomorTelpon(),
                  _buildAlamatField(),
                  _buildTowerField(),
                  _buildRTField(),
                  _buildRWField(),
                  const SizedBox(height: Styles.defaultSpacing),
                  _buildDoneButton(),
                  Container(
                    width: 100.w,
                    height: 5.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      maxCharacter: 50,
      controller: _nameController,
      hintText: "Masukkan nama Anda",
      fillColor: ColorValues.white,
      label: "Nama",
    );
  }

  Widget _buildNomorTelpon() {
    return CustomTextField(
      maxCharacter: 13,
      controller: _noTelponController,
      hintText: "Masukkan nomor telpon Anda",
      fillColor: ColorValues.white,
      label: "Nomor Telpon",
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildAlamatField() {
    return CustomTextField(
      maxCharacter: 50,
      controller: _addressController,
      hintText: "Masukkan alamat rumah Anda",
      fillColor: ColorValues.white,
      label: "Alamat",
    );
  }

  Widget _buildRTField() {
    return CustomTextField(
      maxCharacter: 2,
      controller: _rtController,
      hintText: "Masukkan RT Anda",
      fillColor: ColorValues.white,
      label: "RT",
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildRWField() {
    return CustomTextField(
      maxCharacter: 2,
      controller: _rwController,
      hintText: "Masukkan RW Anda",
      fillColor: ColorValues.white,
      label: "RW",
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildTowerField() {
    return CustomTextField(
      maxCharacter: 50,
      controller: _towerController,
      hintText: "Masukkan alamat tower Anda",
      fillColor: ColorValues.white,
      label: "Tower",
    );
  }

  Widget _buildDoneButton() {
    return CustomButton(
      backgroundColor: Colors.blue,
      text: "Lanjutkan",
      width: double.infinity,
      onPressed: () {
        _saveUserDataToFirestore();
        AutoRouter.of(context).replace(HomeWrapperRoute());
      },
    );
  }

  Future<void> _saveUserDataToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final collectionRef = FirebaseFirestore.instance.collection('Customer');
      final count = await collectionRef.count().get();
      final countValue = count.count;
      String counts = '$countValue';
      if (user != null) {
        String userId = user.uid;
        await FirebaseFirestore.instance
            .collection('Customer')
            .doc(userId)
            .set({
          'nama': _nameController.text,
          'alamatTower': _towerController.text,
          'alamat': _addressController.text,
          'rt': _rtController.text,
          'rw': _rwController.text,
          'noTelpon': _noTelponController.text,
          'customer_no': _rtController.text + _rwController.text + counts,
        });
        print('Data pelanggan berhasil disimpan di Firestore.');
      } else {
        print('Tidak ada pengguna yang sedang login.');
      }
    } catch (error) {
      print("Error: $error");
    }
  }
}
