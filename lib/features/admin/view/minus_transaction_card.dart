import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:perairan_ngale/models/transaksi.dart';
import 'package:perairan_ngale/shared/color_values.dart';
import 'package:perairan_ngale/shared/date_helper.dart';
import 'package:perairan_ngale/shared/styles.dart';
import 'package:perairan_ngale/utils/extensions.dart';

class MinusTransactionCard extends StatelessWidget {
  const MinusTransactionCard({super.key, required this.transaksi});
  final Transaksi transaksi;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.smallerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHistoryItemWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItemWidget(BuildContext context) {
    final saldo = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
        .format(transaksi.saldo);
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
                IconsaxPlusLinear.arrow_up,
                size: Styles.bigIcon,
                color: Colors.red,
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
                        "Admin",
                        style: context.textTheme.bodyMediumBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '- $saldo',
                        style: context.textTheme.bodyMediumBold.copyWith(color: Colors.red),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: Styles.smallSpacing,
                      ),
                      Text(
                        DateHelper.formatDateToDayMonthYearTime(
                            transaksi.tanggal),
                        style: context.textTheme.bodySmallGrey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}