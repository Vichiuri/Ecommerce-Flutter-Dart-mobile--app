import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';

@lazySingleton
class FetchByCategory
    extends UseCase<DashBoardResponse, FetchByCategoryParams> {
  FetchByCategory(this._repository);

  @override
  Future<Either<String, DashBoardResponse>> call(FetchByCategoryParams params) {
    return _repository.fetchByCategory(
      catId: params.id,
      page: params.page,
    );
  }

  final Repository _repository;
}

class FetchByCategoryParams {
  final int id;
  final int? page;
  FetchByCategoryParams({
    required this.id,
    this.page,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchByCategoryParams &&
        other.id == id &&
        other.page == page;
  }

  @override
  int get hashCode => id.hashCode ^ page.hashCode;

  @override
  String toString() => 'FetchByCategoryParams(id: $id, page: $page)';
}
