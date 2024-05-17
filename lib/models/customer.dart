import 'package:freezed_annotation/freezed_annotation.dart';
part 'customer.freezed.dart';
part 'customer.g.dart';


@freezed
class Customer with _$Customer {
  const factory Customer({
    required String uid,
    String? customerNo,
    required String nama,
    required String alamat,
    required String rt,
    required String rw,
  }) = _Customer;

  factory Customer.fromJson(Map<String, Object> json) => _$CustomerFromJson(json);
}
