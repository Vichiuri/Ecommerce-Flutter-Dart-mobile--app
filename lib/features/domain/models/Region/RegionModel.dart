import 'package:json_annotation/json_annotation.dart';

part 'RegionModel.g.dart';

@JsonSerializable()
class RegionModel {
  final int id;
  final String name;

  RegionModel({required this.id, required this.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionModelToJson(this);
}
