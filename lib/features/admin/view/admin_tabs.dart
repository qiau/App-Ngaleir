import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/features/admin/save_file_mobile.dart';
import 'package:perairan_ngale/models/admin.dart';
import 'package:perairan_ngale/models/customer.dart';
import 'package:perairan_ngale/models/transaksi.dart';
import 'package:perairan_ngale/routes/router.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/utils/extensions.dart';
import 'package:perairan_ngale/utils/logger.dart';
import 'package:perairan_ngale/widgets/custom_gesture_unfocus.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'dart:io';

@RoutePage()
class AdminTabsPage extends StatefulWidget {
  const AdminTabsPage({super.key});

  @override
  State<AdminTabsPage> createState() => _AdminTabsPageState();
}

class _AdminTabsPageState extends State<AdminTabsPage> {
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late TransaksiDataSource transaksiDataSource;
  List<Transaksi> transaksiList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTransaksi();
  }

  Future<void> _exportDataGridToExcel() async {
    logger.d('current state key ${key.currentState}');
    final xlsio.Workbook workbook = key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final helper = SaveFileMobile();
    await helper.download(bytes, 'DataGrid.xlsx');
  }

  Future<void> fetchTransaksi() async {
    try {
      QuerySnapshot transaksiSnapshot =
          await FirebaseFirestore.instance.collection('Transaksi').get();
      QuerySnapshot customerSnapshot =
          await FirebaseFirestore.instance.collection('Customer').get();
      QuerySnapshot adminSnapshot =
          await FirebaseFirestore.instance.collection('Admin').get();

      Map<String, String> userIdToNameMap = {};

      for (var doc in customerSnapshot.docs) {
        var customer = Customer.fromFirestore(doc);
        userIdToNameMap[customer.uid] = customer.nama;
      }

      for (var doc in adminSnapshot.docs) {
        var admin = Admin.fromFirestore(doc);
        userIdToNameMap[admin.uid] = admin.nama;
      }

      transaksiList = transaksiSnapshot.docs.map((doc) {
        var transaksi = Transaksi.fromFirestore(doc);
        var userName = userIdToNameMap[transaksi.userId] ?? 'Unknown User';
        return transaksi.copyWith(userId: userName);
      }).toList();

      setState(() {
        transaksiDataSource = TransaksiDataSource(transaksiList: transaksiList);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching transactions: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        AdminIncomeRoute(),
        AdminTransactionRoute(),
      ],
      builder: (context, child, controller) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(
                child: Text(
                  "Transaksi",
                  style: context.textTheme.headlineLarge,
                ),
              ),
            ),
            body: CustomGestureUnfocus(
              child: Column(
                children: [
                  Container(
                    width: 100.w,
                    height: 35.h,
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : errorMessage != null
                            ? Center(child: Text(errorMessage!))
                            : SfDataGrid(
                                key: key,
                                source: transaksiDataSource,
                                columns: <GridColumn>[
                                  GridColumn(
                                    columnName: 'nama',
                                    label: Container(
                                      padding: EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Nama',
                                        style: context.textTheme.bodySmallBold,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'tanggal',
                                    label: Container(
                                      padding: EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Tanggal',
                                        style: context.textTheme.bodySmallBold,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'saldo',
                                    label: Container(
                                      padding: EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Nominal',
                                        style: context.textTheme.bodySmallBold,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'deskripsi',
                                    label: Container(
                                      padding: EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Deskripsi',
                                        style: context.textTheme.bodySmallBold,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'status',
                                    label: Container(
                                      padding: EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Status',
                                        style: context.textTheme.bodySmallBold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                  _buildTabBar(controller, tabsRouter, context),
                  Expanded(child: child),
                ],
              ),
            ),
            floatingActionButton: SizedBox(
              height: 64,
              width: 64,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  try {
                    _exportDataGridToExcel();
                  } catch (e) {
                    context.showSnackBar(
                        message: e.toString(), isSuccess: false);
                  }
                },
                child: Icon(
                  IconsaxPlusLinear.printer,
                  size: 44,
                  color: ColorValues.white,
                ),
              ),
            ));
      },
    );
  }

  TabBar _buildTabBar(
    TabController controller,
    TabsRouter tabsRouter,
    BuildContext context,
  ) {
    return TabBar(
      controller: controller,
      onTap: (value) {
        setState(() {
          tabsRouter.setActiveIndex(value);
        });
      },
      tabs: [
        Tab(
          child: Text(
            "Pemasukan",
            style: tabsRouter.activeIndex == 0
                ? context.textTheme.bodyMediumBold
                : context.textTheme.bodyMediumBold.copyWith(
                    color: ColorValues.grey30,
                  ),
          ),
        ),
        Tab(
          child: Text(
            "Pengeluaran",
            style: tabsRouter.activeIndex == 1
                ? context.textTheme.bodyMediumBold
                : context.textTheme.bodyMediumBold.copyWith(
                    color: ColorValues.grey30,
                  ),
          ),
        ),
      ],
      indicatorColor: ColorValues.primary50,
    );
  }
}

class TransaksiDataSource extends DataGridSource {
  TransaksiDataSource({required List<Transaksi> transaksiList}) {
    dataGridRows = transaksiList.map<DataGridRow>((Transaksi transaksi) {
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'nama',
          value: transaksi.userId,
        ),
        DataGridCell<String>(
          columnName: 'tanggal',
          value: transaksi.tanggal,
        ),
        DataGridCell<int>(
          columnName: 'saldo',
          value: transaksi.saldo,
        ),
        DataGridCell<String>(
          columnName: 'deskripsi',
          value: transaksi.deskripsi ?? '-',
        ),
        DataGridCell<String>(
          columnName: 'status',
          value: transaksi.status,
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          dataGridCell.value.toString(),
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
      );
    }).toList());
  }
}
