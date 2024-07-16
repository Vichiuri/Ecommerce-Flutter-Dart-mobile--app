import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String first_name;
  final String last_name;
  final String pin_no;

  UserModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.pin_no,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
