import 'package:json_annotation/json_annotation.dart';
part 'about_model.g.dart';

@JsonSerializable()
class AboutModel {
  final String? about;
  final String? terms;
  final String? privacy;

  AboutModel({
    this.about,
    this.terms,
    this.privacy,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) =>
      _$AboutModelFromJson(json);

  Map<String, dynamic> toJson() => _$AboutModelToJson(this);
}
