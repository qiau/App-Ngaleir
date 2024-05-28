import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perairan_ngale/models/transaksi.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';

@RoutePage()
class EmployeeAddCustomerRecordPage extends StatefulWidget {
  const EmployeeAddCustomerRecordPage(
      {super.key, this.meteranTerakhir, this.transaksi, this.customerId});
  final int? meteranTerakhir;
  final Transaksi? transaksi;
  final String? customerId;

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
  bool isNotEmpty = false;
  @override
  void initState() {
    super.initState();
    setIsNotEmpty();
  }

  void setIsNotEmpty() {
    if (widget.transaksi != null) {
      isNotEmpty = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catat Meter'),
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
            !isNotEmpty
                ? Center(
                    child: SizedBox(
                      width: 343,
                      child: ElevatedButton(
                        // onPressed: _imageUrl == '' ? null : () {},
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Color(0xFF0D9DF8),
                        // ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            'Catat Tagihan',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      )),
    );
  }

  Widget _buildNomorTagihanField() {
    if (widget.meteranTerakhir == 0) {
      _nomorTagihanController.text = 'Tidak ada Data Meteran Bulan Lalu';
    } else {
      _nomorTagihanController.text = widget.meteranTerakhir.toString();
    }
    return CustomTextField(
      maxCharacter: 50,
      controller: _nomorTagihanController,
      enabled: false,
      fillColor: ColorValues.white,
      label: "Meteran Bulan Lalu",
      inputFormatters: [
        widget.meteranTerakhir == 0
            ? FilteringTextInputFormatter.singleLineFormatter
            : FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildMeteranSaatIniField() {
    if (isNotEmpty) {
      _meteranSaatIniController.text = widget.transaksi!.meteran.toString();
    }
    return CustomTextField(
      maxCharacter: 50,
      controller: _meteranSaatIniController,
      fillColor: ColorValues.white,
      label: "Meteran saat ini (m³)",
      enabled: isNotEmpty ? false : true,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }
}
