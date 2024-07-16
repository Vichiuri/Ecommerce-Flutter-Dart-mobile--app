import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/usecase/add_remove_to_fav.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'add_remove_to_fav_event.dart';
part 'add_remove_to_fav_state.dart';

@injectable
class AddRemoveToFavBloc
    extends Bloc<AddRemoveToFavEvent, AddRemoveToFavState> {
  AddRemoveToFavBloc(this._add) : super(AddRemoveToFavInitial());
  final AddRemoveToFav _add;

  @override
  Stream<AddRemoveToFavState> mapEventToState(
    AddRemoveToFavEvent event,
  ) async* {
    if (event is AddRemoveToFavPressed) {
      yield AddRemoveToFavLoading();
      final result = await _add.call(ParamsId(id: event.prodId));
      yield result.fold(
        (l) => AddRemoveToFavError(message: l),
        (r) => AddRemoveToFavSuccess(message: r.message!, id: event.prodId),
      );
    }
  }
}
