import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/Products/slabs_model.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_slabs.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

part 'slabs_event.dart';
part 'slabs_state.dart';

@injectable
class SlabsBloc extends Bloc<SlabsEvent, SlabsState> {
  SlabsBloc(this._slabs) : super(SlabsInitial());
  final GetSlabs _slabs;

  @override
  Stream<SlabsState> mapEventToState(
    SlabsEvent event,
  ) async* {
    if (event is GetSlabsStarted) {
      yield SlabsLoading();
      final _res = await _slabs.call(ParamsId(id: event.prodId));
      yield _res.fold(
          (l) => SlabsError(error: l), (r) => SlabsSuccess(slabs: r.slabs));
    }
  }
}
