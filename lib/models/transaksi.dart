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
    required String userId,
    String? deskripsi,
  }) = _Transaksi;

  factory Transaksi.fromJson(Map<String, dynamic> json) =>
      _$TransaksiFromJson(json);

  factory Transaksi.fromFirestore(DocumentSnapshot doc) {
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        return Transaksi(
          tanggal: data['tanggal'],
          status: data['status'],
          saldo: data['saldo'],
          userId: data['userId'],
          deskripsi: data['deskripsi'],
        );
      } else {
        throw Exception('Document data is null');
      }
    } else {
      throw Exception('Document does not exist');
    }
  }
}