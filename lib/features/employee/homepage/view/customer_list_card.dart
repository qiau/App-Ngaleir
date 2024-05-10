import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:perairan_ngale/utils/extensions.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard(
      {super.key,
      required this.nama,
      required this.alamat,
      required this.noPelanggan});
  final String nama;
  final String alamat;
  final String noPelanggan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(
                            IconsaxPlusBold.profile_circle,
                            size: 35,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nama,
                                  style: context.textTheme.bodyMediumBold,
                                ),
                                Text(noPelanggan),
                                Text(
                                  alamat,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        )
      ],
    );
  }
}
