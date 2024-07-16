import 'package:flutter/foundation.dart';

import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import 'package:biz_mobile_app/features/domain/models/RetailOrder/transport_model.dart';

class TransportResponse {
  final List<TransportModel> transport;
  final String? errors;

  TransportResponse(this.transport) : errors = null;
  TransportResponse.withError(String errorValue)
      : transport = [],
        errors = networkErrorHandler(errorValue);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransportResponse &&
        listEquals(other.transport, transport) &&
        other.errors == errors;
  }

  @override
  int get hashCode => transport.hashCode ^ errors.hashCode;

  @override
  String toString() =>
      'TransportResponse(transport: $transport, errors: $errors)';
}
