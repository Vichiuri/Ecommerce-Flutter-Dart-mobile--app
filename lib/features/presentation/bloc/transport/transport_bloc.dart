import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/transport_response.dart';
import 'package:biz_mobile_app/features/domain/usecase/fetch_transport.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'transport_event.dart';
part 'transport_state.dart';

@injectable
class TransportBloc extends Bloc<TransportEvent, TransportState> {
  TransportBloc(this._get) : super(TransportInitial());
  final FetchTransport _get;

  @override
  Stream<TransportState> mapEventToState(
    TransportEvent event,
  ) async* {
    if (event is FetchTransportEvent) {
      yield TransportLoading();
      final _res = await _get.call(ParamsId(id: event.retId));
      yield _res.fold(
        (l) => TransportError(error: l),
        (r) => TransportSuccess(response: r),
      );
    }
  }
}
