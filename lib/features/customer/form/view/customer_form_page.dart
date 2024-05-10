import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_button.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorValues.grey10,
        appBar: AppBar(
          backgroundColor: ColorValues.grey10,
          title: Padding(
            padding: EdgeInsets.only(left: Styles.smallerPadding),
            child: Text(
              'Silakan isi data diri Anda',
              style: context.textTheme.titleLarge,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              IconsaxPlusLinear.arrow_left_1,
              size: Styles.defaultIcon,
            ),
            onPressed: () {
              AutoRouter.of(context).maybePop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
            child: Column(
              children: [
                _buildNameField(),
                _buildAlamatField(),
                _buildRTField(),
                _buildRWField(),
                const SizedBox(height: Styles.defaultSpacing),
                _buildDoneButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(){
    return CustomTextField(
      maxCharacter: 50,
      controller: _nameController,
      hintText: "Masukkan nama Anda",
      fillColor: ColorValues.white,
      label: "Nama",
    );
  }

  Widget _buildAlamatField(){
    return CustomTextField(
      maxCharacter: 50,
      controller: _addressController,
      hintText: "Masukkan alamat Anda",
      fillColor: ColorValues.white,
      label: "Alamat",
    );
  }

  Widget _buildRTField(){
    return CustomTextField(
      maxCharacter: 2,
      controller: _rtController,
      hintText: "Masukkan RT Anda",
      fillColor: ColorValues.white,
      label: "RT",
    );
  }

  Widget _buildRWField(){
    return CustomTextField(
      maxCharacter: 2,
      controller: _rwController,
      hintText: "Masukkan RW Anda",
      fillColor: ColorValues.white,
      label: "RW",
    );
  }

  Widget _buildDoneButton() {
    return CustomButton(
      backgroundColor: Colors.blue,
      text: "Lanjutkan",
      width: double.infinity,
      onPressed: () {
        AutoRouter.of(context).push(CustomerHomeRoute());
      },
    );
  }
}
