import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/Category/CategoryModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_categories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'all_category_event.dart';
part 'all_category_state.dart';

@injectable
class AllCategoryBloc extends Bloc<AllCategoryEvent, AllCategoryState> {
  AllCategoryBloc(this._categories) : super(AllCategoryInitial());
  final GetCategories _categories;

  @override
  Stream<AllCategoryState> mapEventToState(
    AllCategoryEvent event,
  ) async* {
    if (event is GetAllCategoryEvent) {
      yield AllCategoryLoading();
      final _res = await _categories.call(ParamsIdNullable(id: event.page));
      yield _res.fold(
        (l) => AllCategoryError(error: l),
        (r) => AllCategorySuccess(
          categories: r.categories,
          currentPage: r.currentPage,
          lastPage: r.lastPage,
        ),
      );
    }
  }
}
