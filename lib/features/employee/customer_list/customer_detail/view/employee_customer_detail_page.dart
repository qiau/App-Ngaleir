import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:perairan_ngale/features/transaction_card.dart';
import 'package:perairan_ngale/models/customer.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:perairan_ngale/models/transaksi.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';

@RoutePage()
class EmployeeCustomerDetailPage extends StatefulWidget {
  const EmployeeCustomerDetailPage({
    super.key,
    required this.customer,
  });
  final Customer customer;

  @override
  State<EmployeeCustomerDetailPage> createState() =>
      _EmployeeCustomerDetailPageState();
}

class _EmployeeCustomerDetailPageState
    extends State<EmployeeCustomerDetailPage> {
  List<Transaksi> listTransaksi = [];

  Future<void> getTransaksiByUserIdAndYear(String userId) async {
    final tahun = DateTime.now().year;
    final collection = FirebaseFirestore.instance.collection('Transaksi');
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to view this page')),
      );
      return;
    }

    final startOfYear = DateTime(tahun - 1, 12, 1).toIso8601String();
    final endOfYear = DateTime(tahun + 1, 1, 1).toIso8601String();

    final querySnapshot = await collection
        .where('userId', isEqualTo: userId)
        .where('tanggal', isGreaterThanOrEqualTo: startOfYear)
        .where('tanggal', isLessThan: endOfYear)
        .orderBy('tanggal', descending: true)
        .get();

    setState(() {
      listTransaksi = querySnapshot.docs
          .map((doc) => Transaksi.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getTransaksiByUserIdAndYear(widget.customer.uid);
  }

  @override
  Widget build(BuildContext context) {
    var meteranTerakhir = 0;
    var isThereTransaksi = false;
    if (listTransaksi.isNotEmpty) {
      meteranTerakhir = listTransaksi[0].meteran!;
      isThereTransaksi = true;
    }
    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: Styles.biggerPadding),
        child: ElevatedButton(
          onPressed: () {
            AutoRouter.of(context).push(EmployeeAddCustomerRecordRoute(
              isThereTransaksi: isThereTransaksi,
              meteranTerakhir: meteranTerakhir,
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconsaxPlusLinear.add,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Catat Baru',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: ColorValues.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildTopBarWidget(), _buildRecordsWidget()],
        ),
      ),
    );
  }

  Widget _buildTopBarWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: svg.Svg('assets/Frame 6.svg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Center(child: _buildTopBarContentWidget()),
        ],
      ),
    );
  }

  Widget _buildTopBarContentWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Styles.defaultPadding),
        child: Column(
          children: [
            Container(
              child: Icon(IconsaxPlusBold.profile_circle,
                  size: Styles.bigIcon, color: Colors.white),
            ),
            Text(
              widget.customer.nama,
              style: context.textTheme.titleLargeBright,
              textAlign: TextAlign.center,
            ),
            Text(
              widget.customer.customerNo,
              style: context.textTheme.bodyMediumBoldBright,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: ColorValues.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Styles.defaultPadding),
        child: Column(
          children: [
            Center(
              child: Text(
                "Riwayat Pencatatan",
                style: context.textTheme.bodyMediumBold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listTransaksi.length,
                itemBuilder: (context, index) {
                  int? meteranTerakhir = 0;
                  if (index != listTransaksi.length - 1) {
                    meteranTerakhir = listTransaksi[index + 1].meteran;
                  }
                  Transaksi transaksi = listTransaksi[index];
                  return TransactionCard(
                    transaksi: transaksi,
                    meteranTerakhir: meteranTerakhir,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
