import 'package:json_annotation/json_annotation.dart';

part 'contact_model.g.dart';

@JsonSerializable()
class ContactModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "phone")
  final String phone;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ phone.hashCode;

  @override
  String toString() => 'ContactModel(id: $id, name: $name, phone: $phone)';
}
