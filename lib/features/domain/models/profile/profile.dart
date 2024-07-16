import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String? pic;

  ProfileModel(
      {required this.name, required this.email, required this.phone, this.pic});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
