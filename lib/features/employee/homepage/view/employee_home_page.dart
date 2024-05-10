import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/features/employee/homepage/customer_dummy.dart';
import 'package:perairan_ngale/features/employee/homepage/view/customer_list_card.dart';
import 'package:perairan_ngale/shared/app_text_styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';

@RoutePage()
class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({Key? key}) : super(key: key);

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  late TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            SizedBox(height: 16),
            Expanded(child: _CustomerList()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8, right: 16, left: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo,',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Petugas 1',
                      style: context.textTheme.displayLarge,
                    ),
                  ],
                ),
                GestureDetector(
                  child: Icon(
                    IconsaxPlusBold.profile_circle,
                    size: 40,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<_CustomerList> {
  late List<Customer> listCustomer = generateDummyCustomers();
  late List<Customer> filteredCustomer = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredCustomer = listCustomer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    filteredCustomer = listCustomer.where((customer) {
                      return customer.nama
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Cari pelanggan',
                  prefixIcon: Icon(
                    IconsaxPlusLinear.search_normal,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCustomer.length,
                itemBuilder: (context, index) {
                  Customer customer = filteredCustomer[index];
                  return GestureDetector(
                    child: CustomerCard(
                      nama: customer.nama,
                      noPelanggan: customer.noPelanggan,
                      alamat: customer.alamat,
                    ),
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
