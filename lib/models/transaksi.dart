import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'transaksi.freezed.dart';
part 'transaksi.g.dart';

@freezed
class Transaksi with _$Transaksi {
  const factory Transaksi({
    required String tanggal,
    required String status,
    required int saldo,
    required int meteran,
    required String userId,
  }) = _Transaksi;

  factory Transaksi.fromJson(Map<String, dynamic> json) =>
      _$TransaksiFromJson(json);
}
