import 'package:freezed_annotation/freezed_annotation.dart';
part 'admin.freezed.dart';
part 'admin.g.dart';

@freezed
class Admin with _$Admin {
  const factory Admin({
    required String uid,
    required String nama,
  }) = _Admin;

  factory Admin.fromJson(Map<String, Object> json) => _$AdminFromJson(json);
}