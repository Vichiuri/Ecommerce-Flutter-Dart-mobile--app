import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:biz_mobile_app/features/domain/models/RetailOrder/ret_orders_model.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';

import 'contact_model.dart';

part 'retail_order_model.g.dart';

@JsonSerializable()
class RetailOrdersModel {
  RetailOrdersModel({
    required this.id,
    required this.retOrders,
    required this.totalCostCurrency,
    required this.totalCost,
    required this.status,
    this.whenPlaced,
    this.whenApproved,
    this.whenDeclined,
    this.whenDispatched,
    this.whenHeld,
    this.note,
    required this.paymentTerms,
    required this.distributor,
    this.retailer,
    this.salesman,
    required this.priceLevel,
    required this.confirmDelivery,
    required this.referenceNumber,
  });

  factory RetailOrdersModel.fromJson(Map<String, dynamic> json) =>
      _$RetailOrdersModelFromJson(json);

  Map<String, dynamic> toJson() => _$RetailOrdersModelToJson(this);

  final int id;
  // final DistributorsModel distributor;
  @JsonKey(name: "ret_orders")
  final List<RetOrderModel> retOrders;
  @JsonKey(name: "total_cost_currency")
  final String totalCostCurrency;
  @JsonKey(name: "total_cost")
  final String totalCost;
  final String status;
  @JsonKey(name: "when_placed")
  final String? whenPlaced;
  @JsonKey(name: "when_approved")
  final String? whenApproved;
  @JsonKey(name: "when_declined")
  final String? whenDeclined;
  @JsonKey(name: "when_dispatched")
  final String? whenDispatched;
  @JsonKey(name: "when_held")
  final String? whenHeld;
  final String? note;
  @JsonKey(name: "payment_terms")
  final String paymentTerms;
  final DistributorsModel distributor;
  @JsonKey(name: "retailer", includeIfNull: false)
  final ContactModel? retailer;
  @JsonKey(name: "salesman", includeIfNull: false)
  final ContactModel? salesman;
  final double? priceLevel;
  @JsonKey(name: "confirmed_delivery")
  final bool? confirmDelivery;
  @JsonKey(name: "ref_number")
  final String? referenceNumber;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RetailOrdersModel &&
        other.id == id &&
        listEquals(other.retOrders, retOrders) &&
        other.totalCostCurrency == totalCostCurrency &&
        other.totalCost == totalCost &&
        other.status == status &&
        other.whenPlaced == whenPlaced &&
        other.whenApproved == whenApproved &&
        other.whenDeclined == whenDeclined &&
        other.whenDispatched == whenDispatched &&
        other.whenHeld == whenHeld &&
        other.note == note &&
        other.paymentTerms == paymentTerms &&
        other.distributor == distributor &&
        other.retailer == retailer &&
        other.salesman == salesman &&
        other.priceLevel == priceLevel &&
        other.confirmDelivery == confirmDelivery &&
        other.referenceNumber == referenceNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        retOrders.hashCode ^
        totalCostCurrency.hashCode ^
        totalCost.hashCode ^
        status.hashCode ^
        whenPlaced.hashCode ^
        whenApproved.hashCode ^
        whenDeclined.hashCode ^
        whenDispatched.hashCode ^
        whenHeld.hashCode ^
        note.hashCode ^
        paymentTerms.hashCode ^
        distributor.hashCode ^
        retailer.hashCode ^
        salesman.hashCode ^
        priceLevel.hashCode ^
        confirmDelivery.hashCode ^
        referenceNumber.hashCode;
  }

  @override
  String toString() {
    return 'RetailOrdersModel(id: $id, retOrders: $retOrders, totalCostCurrency: $totalCostCurrency, totalCost: $totalCost, status: $status, whenPlaced: $whenPlaced, whenApproved: $whenApproved, whenDeclined: $whenDeclined, whenDispatched: $whenDispatched, whenHeld: $whenHeld, note: $note, paymentTerms: $paymentTerms, distributor: $distributor, retailer: $retailer, salesman: $salesman, priceLevel: $priceLevel, confirmDelivery: $confirmDelivery, referenceNumber: $referenceNumber)';
  }
}
