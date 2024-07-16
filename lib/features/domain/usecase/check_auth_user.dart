import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CheckAuthUser extends UseCase<bool, NoParams> {
  final Repository _repository;

  CheckAuthUser(this._repository);

  @override
  Future<Either<String, bool>> call(NoParams params) {
    return _repository.checkAuthUser();
  }
}
