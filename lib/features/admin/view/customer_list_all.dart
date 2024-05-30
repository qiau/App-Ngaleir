import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:perairan_ngale/features/employee/homepage/view/customer_list_card.dart';
import 'package:perairan_ngale/models/admin.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:perairan_ngale/widgets/custom_text_field.dart';

class CustomerListAll extends StatefulWidget {
  const CustomerListAll({super.key, required this.admin});
  final Admin admin;

  @override
  State<CustomerListAll> createState() => _CustomerListAllState();
}

class _CustomerListAllState extends State<CustomerListAll> {
  late TextEditingController _searchController;
  final PaginateRefreshedChangeListener refreshChangeListener =
  PaginateRefreshedChangeListener();

  final ValueNotifier<String> _searchQuery = ValueNotifier<String>('');
  var searchname = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchQuery.value = _searchController.text;
  }

  void _onSearchSubmitted(String value) {
    print("Search submitted: $value"); // Debug statement
    _searchQuery.value = value;
    refreshChangeListener.refreshed = true;
    print("Refresh triggered"); // Debug statement
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
              child: CustomTextField(
                hintText: 'Cari pelanggan',
                prefixIcon: IconsaxPlusLinear.search_normal,
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchname = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: _searchQuery,
                builder: (context, value, _) {
                  print("Search query: $value"); // Debug statement
                  return value.isEmpty
                      ? _buildListNoSearch()
                      : _buildListWithSearch();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListNoSearch() {
    return RefreshIndicator(
        onRefresh: () async {
          refreshChangeListener.refreshed = true;
        },
        child: FirestoreListView<Map<String, dynamic>>(
          pageSize: 3,
          query: FirebaseFirestore.instance
              .collection('Customer')
              .orderBy('nama'),
          itemBuilder: (context, snapshot) {
            Map<String, dynamic> user = snapshot.data();
            return CustomerCard(
              nama: user['nama'],
              alamat: user['alamat'],
              noPelanggan: user['customer_no'],
            );
          },
        ));
  }

  Widget _buildListWithSearch() {
    return RefreshIndicator(
      onRefresh: () async {
        refreshChangeListener.refreshed = true;
      },
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Customer')
              .orderBy('nama')
              .startAt([searchname]).endAt([searchname + "\uf8ff"]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return CustomerCard(
                    nama: data['nama'],
                    alamat: data['alamat'],
                    noPelanggan: data['customer_no']);
              },
            );
          }),
    );
  }
}