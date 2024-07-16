import 'package:json_annotation/json_annotation.dart';

part 'PriceLevelModel.g.dart';

@JsonSerializable()
class PriceLevelModel {
  final int id;
  final String level_name;

  PriceLevelModel({required this.id, required this.level_name});

  factory PriceLevelModel.fromJson(Map<String, dynamic> json) =>
      _$PriceLevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceLevelModelToJson(this);
}
