import 'package:json_annotation/json_annotation.dart';

import '../distributors/Distributors.dart';

part 'RetailerModel.g.dart';

@JsonSerializable()
class RetailerModel {
  final int id;
  @JsonKey(name: "pin_no")
  final String pinNo;
  final String name;
  final String phone;
  final String email;
  final String? pic;
  final List<DistributorsModel>? distributors;

  RetailerModel({
    required this.id,
    required this.pinNo,
    required this.name,
    required this.phone,
    required this.email,
    this.pic,
    this.distributors,
  });

  factory RetailerModel.fromJson(Map<String, dynamic> json) =>
      _$RetailerModelFromJson(json);

  Map<String, dynamic> toJson() => _$RetailerModelToJson(this);
}
