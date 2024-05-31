import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perairan_ngale/models/employee.dart';
import 'package:perairan_ngale/models/transaksi.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/widgets/custom_gesture_unfocus.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';

@RoutePage()
class EmployeeAddCustomerRecordPage extends StatefulWidget {
  const EmployeeAddCustomerRecordPage(
      {super.key,
      this.meteranTerakhir,
      this.transaksi,
      this.customerId,
      required this.isThereTransaksi, required this.employee,});

  final int? meteranTerakhir;
  final Transaksi? transaksi;
  final String? customerId;
  final bool isThereTransaksi;
  final Employee employee;

  @override
  State<EmployeeAddCustomerRecordPage> createState() =>
      _EmployeeAddCustomerRecordPageState();
}

class _EmployeeAddCustomerRecordPageState
    extends State<EmployeeAddCustomerRecordPage> {
  late final Employee _employee;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomorTagihanController = TextEditingController();
  final TextEditingController _meteranSaatIniController =
      TextEditingController();
  final TextEditingController _pencatatController = TextEditingController();
  late String _imagePath = '';
  bool loading = false;
  bool isNotEmpty = false;

  @override
  void initState() {
    super.initState();
    setIsNotEmpty();
    getPencatat();
  }

  late File? _imageFile = null;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {}
  }

  Future<void> getPencatat() async {
    final doc = await FirebaseFirestore.instance
        .collection('Employee')
        .doc(FirebaseAuth.instance.currentUser!.uid) // cuman work sebagai petugas
        .get();
    final _employee = Employee.fromFirestore(doc);
    _pencatatController.text = _employee.nama;
  }

  String url = '';

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = path.basename(_imageFile!.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('transaksi/$fileName');
    _imagePath = 'transaksi/' + fileName;
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    url = await taskSnapshot.ref.getDownloadURL();
    setState(() {}); // Add this line to update the UI after uploading the image
    _getImageUrl(); // Add this line to update the url if necessary
  }

  final storageReference = FirebaseStorage.instance.ref();

  void setIsNotEmpty() async {
    if (widget.transaksi != null) {
      isNotEmpty = true;
      if (widget.transaksi?.pathImage! == '') {
        _imagePath = 'transaksi/default.jpg';
      } else {
        _imagePath = widget.transaksi!.pathImage!;
      }

      Reference getImage = storageReference.child(_imagePath);
      print(_imagePath);
      setState(() {
        loading = true;
      });
      _imagePath = await getImage.getDownloadURL();
      setState(() {
        loading = false;
      });
    }
  }

  Future<String> _getImageUrl() async {
    if (url.isNotEmpty) {
      return url;
    } else {
      final defaultImage = storageReference.child("transaksi/default.jpg");
      final snapshot = await defaultImage.getDownloadURL();
      if (url.isEmpty) {
        url = snapshot;
      }
      return snapshot;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catat Meter'),
      ),
      body: CustomGestureUnfocus(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                _buildPencatatField(),
                SizedBox(
                  height: Styles.biggerSpacing,
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
                    onTap: () async {
                      if (!isNotEmpty) {
                        await pickImage();
                        if (_imageFile != null) {
                          if (_imageFile!.path.isNotEmpty) {
                            setState(() {
                              loading = true;
                            });
                            await uploadImageToFirebase(context);
                            setState(() {
                              loading = false;
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal mengambil gambar')),
                          );
                        }
                      }
                    },
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : isNotEmpty
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    _imagePath,
                                    cacheHeight: 189,
                                    cacheWidth: 343,
                                  ),
                                ),
                              )
                            : FutureBuilder(
                                future: _getImageUrl(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error loading image'),
                                    );
                                  } else {
                                    return Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          snapshot.data!,
                                          cacheHeight: 189,
                                          cacheWidth: 343,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )),
                SizedBox(height: 16),
                !isNotEmpty
                    ? Center(
                        child: SizedBox(
                          width: 343,
                          child: ElevatedButton(
                            onPressed: () {
                              _tambahTransaksi(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                'Catat Tagihan',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> _tambahTransaksi(BuildContext context) async {
    int pemakaian1bulan;
    if (_formKey.currentState!.validate()) {
      if (!widget.isThereTransaksi) {
        int meteranTerakhir = int.parse(_nomorTagihanController.text);

        pemakaian1bulan =
            int.parse(_meteranSaatIniController.text) - meteranTerakhir;
      } else {
        pemakaian1bulan =
            int.parse(_meteranSaatIniController.text) - widget.meteranTerakhir!;
      }

      int saldo = pemakaian1bulan * 5000;
      try {
        if (saldo > 0) {
          final transaksi = Transaksi(
            deskripsi: 'Pembayaran Air',
            saldo: saldo,
            meteran: int.parse(_meteranSaatIniController.text),
            status: 'pembayaran',
            tanggal: Timestamp.now().toDate().toString(),
            userId: widget.customerId ?? '',
            employeeId: FirebaseAuth.instance.currentUser!.uid,
            pathImage: _imagePath,
            bulan: Timestamp.now().toDate().month,
            tahun: Timestamp.now().toDate().year,
          );

          await FirebaseFirestore.instance
              .collection('Transaksi')
              .add(transaksi.toJson());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tambah Transaksi Berhasil')),
          );
          AutoRouter.of(context).pushAndPopUntil(EmployeeHomeRoute(),
              predicate: (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Meteran saat ini kurang dari Meteran bulan lalu')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Widget _buildNomorTagihanField() {
    if (widget.meteranTerakhir == 0) {
      if (widget.isThereTransaksi) {
        _nomorTagihanController.text = 'Tidak ada data meteran bulan lalu';
      }
    } else {
      _nomorTagihanController.text = widget.meteranTerakhir.toString();
    }
    return CustomTextField(
      maxCharacter: 50,
      controller: _nomorTagihanController,
      enabled: !widget.isThereTransaksi,
      fillColor: ColorValues.white,
      label: "Meteran Bulan Lalu",
      validator: (value) {
        if (value!.isEmpty) {
          return 'Meteran tidak boleh kosong!';
        }
        return null;
      },
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
      validator: (value) {
        if (value!.isEmpty) {
          return 'Meteran tidak boleh kosong!';
        }
        return null;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPencatatField() {
    if (isNotEmpty) {
      return CustomTextField(
        controller: _pencatatController,
        fillColor: ColorValues.white,
        label: "Pencatat",
      );
    } return SizedBox();
  }
}
