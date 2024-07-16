import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_categories.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_single_category.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'get_category_event.dart';
part 'get_category_state.dart';

@injectable
class GetCategoryBloc extends Bloc<GetCategoryEvent, GetCategoryState> {
  GetCategoryBloc(this._categories, this._single) : super(GetCategoryInitial());
  final GetCategories _categories;
  final GetSingleCategory _single;

  @override
  Stream<GetCategoryState> mapEventToState(
    GetCategoryEvent event,
  ) async* {
    if (event is GetCategoryStarted) {
      yield GetCategoryLoading();
      final res = await _categories.call(ParamsIdNullable(id: event.page));
      yield res.fold(
        (l) => GetCategoryError(message: l),
        (r) => GetCategorySuccess(response: r),
      );
    }
    if (event is GetCategoryUpdate) {
      yield GetCategoryUpdating();
      final res = await _categories.call(ParamsIdNullable(id: event.page));
      yield res.fold(
        (l) => GetCategoryError(message: l),
        (r) => GetCategorySuccess(response: r),
      );
    }
    if (event is GetCategorySingleEvent) {
      yield GetCategoryLoading();
      final res = await _single.call(ParamsId(id: event.categoryId));
      yield res.fold(
        (l) => GetCategoryError(message: l),
        (r) => GetCategorySuccess(response: r),
      );
    }
  }
}
