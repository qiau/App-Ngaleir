import 'package:perairan_ngale/models/customer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
class Employee with _$Employee {
  const factory Employee({
    required String uid,
    required String nama,
    required List<Customer> customers,
  }) = _Employee;

  factory Employee.fromJson(Map<String, Object> json) => _$EmployeeFromJson(json);
}