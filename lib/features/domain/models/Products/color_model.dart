import 'package:json_annotation/json_annotation.dart';
part 'color_model.g.dart';

@JsonSerializable()
class ColorModel {
  @JsonKey(name: "color")
  final String color;

  ColorModel({
    required this.color,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) =>
      _$ColorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ColorModelToJson(this);
}
