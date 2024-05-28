import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perairan_ngale/models/transaksi.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';

@RoutePage()
class EmployeeAddCustomerRecordPage extends StatefulWidget {
  const EmployeeAddCustomerRecordPage(
      {super.key,
      this.meteranTerakhir,
      this.transaksi,
      this.customerId,
      this.isThereTransaksi});
  final int? meteranTerakhir;
  final Transaksi? transaksi;
  final String? customerId;
  final bool? isThereTransaksi;

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
  
  StorageReference storageReference = FirebaseStorage.instance.ref();
  File _image;

void getImage() async{
    _image = await ImagePicker.pickImage(source: ImageSource.gallery); 
}

void addImageToFirebase(){


    //CreateRefernce to path.
    StorageReference ref = storageReference.child("yourstorageLocation/");

    //StorageUpload task is used to put the data you want in storage
    //Make sure to get the image first before calling this method otherwise _image will be null.

    StorageUploadTask storageUploadTask = ref.child("image1.jpg").putFile(_image);

     if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
          final String url = await ref.getDownloadURL();
          print("The download URL is " + url);
     } else if (storageUploadTask.isInProgress) {

          storageUploadTask.events.listen((event) {
          double percentage = 100 *(event.snapshot.bytesTransferred.toDouble() 
                               / event.snapshot.totalByteCount.toDouble());  
          print("THe percentage " + percentage.toString());
          });

          StorageTaskSnapshot storageTaskSnapshot =await storageUploadTask.onComplete;
          downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();

          //Here you can get the download URL when the task has been completed.
          print("Download URL " + downloadUrl1.toString());

     } else{
          //Catch any cases here that might come up like canceled, interrupted 
     }

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
      if (widget.isThereTransaksi!) {
        _nomorTagihanController.text = 'Tidak ada Data Meteran Bulan Lalu';
      } else {
        _nomorTagihanController.text = '0';
      }
    } else {
      _nomorTagihanController.text = widget.meteranTerakhir.toString();
    }
    return CustomTextField(
      maxCharacter: 50,
      controller: _nomorTagihanController,
      enabled: widget.isThereTransaksi,
      fillColor: ColorValues.white,
      label: "Meteran Bulan Lalu",
      inputFormatters: [
        widget.meteranTerakhir == 0 && widget.isThereTransaksi == true
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
