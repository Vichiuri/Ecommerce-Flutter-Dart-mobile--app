// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retail_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetailOrdersModel _$RetailOrdersModelFromJson(Map<String, dynamic> json) =>
    RetailOrdersModel(
      id: json['id'] as int,
      retOrders: (json['ret_orders'] as List<dynamic>)
          .map((e) => RetOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCostCurrency: json['total_cost_currency'] as String,
      totalCost: json['total_cost'] as String,
      status: json['status'] as String,
      whenPlaced: json['when_placed'] as String?,
      whenApproved: json['when_approved'] as String?,
      whenDeclined: json['when_declined'] as String?,
      whenDispatched: json['when_dispatched'] as String?,
      whenHeld: json['when_held'] as String?,
      note: json['note'] as String?,
      paymentTerms: json['payment_terms'] as String,
      distributor: DistributorsModel.fromJson(
          json['distributor'] as Map<String, dynamic>),
      retailer: json['retailer'] == null
          ? null
          : ContactModel.fromJson(json['retailer'] as Map<String, dynamic>),
      salesman: json['salesman'] == null
          ? null
          : ContactModel.fromJson(json['salesman'] as Map<String, dynamic>),
      priceLevel: (json['priceLevel'] as num?)?.toDouble(),
      confirmDelivery: json['confirmed_delivery'] as bool?,
      referenceNumber: json['ref_number'] as String?,
    );

Map<String, dynamic> _$RetailOrdersModelToJson(RetailOrdersModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'ret_orders': instance.retOrders,
    'total_cost_currency': instance.totalCostCurrency,
    'total_cost': instance.totalCost,
    'status': instance.status,
    'when_placed': instance.whenPlaced,
    'when_approved': instance.whenApproved,
    'when_declined': instance.whenDeclined,
    'when_dispatched': instance.whenDispatched,
    'when_held': instance.whenHeld,
    'note': instance.note,
    'payment_terms': instance.paymentTerms,
    'distributor': instance.distributor,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('retailer', instance.retailer);
  writeNotNull('salesman', instance.salesman);
  val['priceLevel'] = instance.priceLevel;
  val['confirmed_delivery'] = instance.confirmDelivery;
  val['ref_number'] = instance.referenceNumber;
  return val;
}
