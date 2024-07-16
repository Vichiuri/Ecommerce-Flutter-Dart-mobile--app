import 'package:json_annotation/json_annotation.dart';

part 'UnitModel.g.dart';

@JsonSerializable()
class UnitModel {
  final int id;
  final String? name;
  final String? symbol;

  UnitModel({
    required this.id,
    required this.name,
    required this.symbol,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}
