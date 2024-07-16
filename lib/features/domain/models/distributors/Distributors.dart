import 'package:biz_mobile_app/features/domain/models/distributors/about_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Distributors.g.dart';

@JsonSerializable()
class DistributorsModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? website;
  // final int country;
  // final int state;
  final String address;
  final String description;
  final String? category;
  final String? logo;
  @JsonKey(name: "about_company")
  final AboutModel? about;

  DistributorsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.about,
    this.website,
    // required this.country,
    // required this.state,
    required this.address,
    required this.description,
    this.category,
    this.logo,
  });

  factory DistributorsModel.fromJson(Map<String, dynamic> json) =>
      _$DistributorsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DistributorsModelToJson(this);
}
