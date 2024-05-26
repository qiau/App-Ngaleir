import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:perairan_ngale/features/transaction_card.dart';
import 'package:perairan_ngale/models/customer.dart';
import 'package:perairan_ngale/models/transaksi.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';

@RoutePage()
class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  Customer? _customer;
  List<Transaksi> listTransaksi = [];

  Future<Customer> getCustomer(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('Customer')
        .doc(userId)
        .get();

    final customer = Customer.fromFirestore(doc);
    return customer;
  }

  Future<void> _getCustomer() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to view this page')),
      );
      return;
    }
    final customer = await getCustomer(user.uid);
    setState(() {
      _customer = customer;
    });
    getTransaksiByUserIdAndYear(user.uid);
  }

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

    final startOfYear = DateTime(tahun, 1, 1).toIso8601String();
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
    _getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: svg.Svg('assets/Frame 6.svg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          _buildTopBarContentWidget(),
        ],
      ),
    );
  }

  Widget _buildTopBarContentWidget() {
    print(listTransaksi.length.toString() + 'mantap');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Styles.defaultPadding),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Styles.defaultPadding),
              child: Icon(
                IconsaxPlusLinear.profile_circle,
                size: Styles.bigIcon,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_customer != null)
                      Text(
                        _customer!.nama,
                        style: context.textTheme.bodyMediumBoldBright,
                      ),
                    const SizedBox(
                      height: Styles.smallSpacing,
                    ),
                    if (_customer != null)
                      Text(
                        _customer!.customerNo,
                        style: context.textTheme.bodySmallBright,
                      ),
                  ]),
            ),
            IconButton(
              icon: const Icon(
                IconsaxPlusLinear.setting,
                size: Styles.bigIcon,
                color: Colors.white,
              ),
              onPressed: () {
                AutoRouter.of(context)
                    .push(CustomerProfileRoute(customer: _customer!));
              },
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
                  Transaksi transaksi = listTransaksi[index];
                  return TransactionCard(
                    transaksi: transaksi,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildHistoryItemWidget() {
    final saldo =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(123456);
    return Container(
      decoration: BoxDecoration(
        color: ColorValues.white,
        borderRadius: BorderRadius.circular(Styles.defaultBorder),
        border: Border.all(
          color: ColorValues.grey30,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Styles.defaultPadding),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Styles.defaultPadding),
              child: Icon(
                IconsaxPlusLinear.shopping_cart,
                size: Styles.bigIcon,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        saldo,
                        style: context.textTheme.bodyMediumBold,
                      ),
                      const SizedBox(
                        height: Styles.smallSpacing,
                      ),
                      Text(
                        "24/04/2024 13:00",
                        style: context.textTheme.bodySmallGrey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Icon(
                IconsaxPlusLinear.arrow_right_3,
                size: Styles.defaultIcon,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
