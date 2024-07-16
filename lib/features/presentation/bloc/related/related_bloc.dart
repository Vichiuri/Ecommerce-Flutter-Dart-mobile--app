import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_related.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

part 'related_event.dart';
part 'related_state.dart';

@injectable
class RelatedBloc extends Bloc<RelatedEvent, RelatedState> {
  RelatedBloc(this._related) : super(RelatedInitial());

  final GetRelated _related;
  @override
  Stream<RelatedState> mapEventToState(
    RelatedEvent event,
  ) async* {
    if (event is GetRelatedStarted) {
      yield RelatedLoading();
      final _res = await _related.call(ParamsId(id: event.prodId));
      yield _res.fold((l) => RelatedError(error: l),
          (r) => RelatedSuccess(related: r.products));
    }
  }
}
