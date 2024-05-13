import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';

@RoutePage()
class EmployeeAddCustomerRecordPage extends StatefulWidget {
  const EmployeeAddCustomerRecordPage({super.key});

  @override
  State<EmployeeAddCustomerRecordPage> createState() =>
      _EmployeeAddCustomerRecordPageState();
}

class _EmployeeAddCustomerRecordPageState
    extends State<EmployeeAddCustomerRecordPage> {
  final TextEditingController _nomorTagihanController = TextEditingController();
  final TextEditingController _meteranSaatIniController =
      TextEditingController();
  late String _imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Catat Meter'),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            _buildNomorTagihanField(),
            SizedBox(
              height: Styles.biggerSpacing,
            ),
            _buildMeteranSaatIniField(),
            SizedBox(
              height: Styles.bigSpacing,
            ),
            Text(
              'Foto Meteran',
              style: context.textTheme.titleMedium,
            ),
            SizedBox(
              height: Styles.defaultSpacing,
            ),
            GestureDetector(
                onTap: () {
                  print('cek');
                },
                child: _imageUrl == ''
                    ? Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/default.jpg',
                            cacheHeight: 189,
                            cacheWidth: 343,
                          ),
                        ),
                      )
                    : Image.network(_imageUrl)),
            SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 343,
                child: ElevatedButton(
                  // onPressed: _imageUrl == '' ? null : () {},
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Color(0xFF0D9DF8),
                  // ),
                  onPressed: () {},
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Catat Tagihan',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildNomorTagihanField() {
    return CustomTextField(
      maxCharacter: 50,
      controller: _nomorTagihanController,
      fillColor: ColorValues.white,
      label: "Nomor Tagihan",
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildMeteranSaatIniField() {
    return CustomTextField(
      maxCharacter: 50,
      controller: _meteranSaatIniController,
      fillColor: ColorValues.white,
      label: "Meteran saat ini (m³)",
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }
}
