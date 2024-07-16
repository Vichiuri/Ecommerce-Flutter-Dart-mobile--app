import 'package:json_annotation/json_annotation.dart';

part 'list_notification_model.g.dart';

@JsonSerializable()
class ListNotificationModel {
  final dynamic id;
  final dynamic distributor;
  final dynamic? product;
  final dynamic? offer;
  final dynamic? order;
  final dynamic? name;
  final dynamic display_text;
  final dynamic detail;
  final String? pic;
  final dynamic status;

  ListNotificationModel({
    required this.id,
    required this.distributor,
    this.product,
    this.offer,
    this.name,
    this.order,
    required this.display_text,
    required this.detail,
    this.pic,
    required this.status,
  });

  factory ListNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$ListNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListNotificationModelToJson(this);
}
