import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_description.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'description_event.dart';
part 'description_state.dart';

@injectable
class DescriptionBloc extends Bloc<DescriptionEvent, DescriptionState> {
  DescriptionBloc(this._desc) : super(DescriptionInitial());
  final GetDescription _desc;

  @override
  Stream<DescriptionState> mapEventToState(
    DescriptionEvent event,
  ) async* {
    if (event is DescriptionStarted) {
      yield DescriptionLoading();
      final _res = await _desc.call(ParamsId(id: event.prodId));
      yield _res.fold((l) => DescriptionError(error: l),
          (r) => DescriptionSuccess(desc: r));
    }
  }
}
