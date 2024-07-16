import 'package:biz_mobile_app/features/domain/models/PriceLevel/PriceLevelModel.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Area/AreaModel.dart';
import '../City/CityModel.dart';
import '../Region/RegionModel.dart';
import '../distributors/Distributors.dart';

part 'SalesManModel.g.dart';

@JsonSerializable()
class SalesManModel {
  final int id;
  // final String pin_no;
  final String first_name;
  final String last_name;
  final String phone;
  final String email;
  // @JsonKey(ignore: true, includeIfNull: false)
  final String? pic;
  final DistributorsModel distributor;
  final List<RetailerModel>? retailers;

  SalesManModel({
    this.pic,
    required this.id,
    // required this.pin_no,
    required this.first_name,
    required this.last_name,
    required this.phone,
    required this.email,
    required this.distributor,
    this.retailers,
  });

  factory SalesManModel.fromJson(Map<String, dynamic> json) =>
      _$SalesManModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesManModelToJson(this);
}
