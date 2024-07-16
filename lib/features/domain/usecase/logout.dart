import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class Logout extends UseCase<void, NoParams> {
  Logout(this._repository);

  @override
  Future<Either<String, void>> call(NoParams params) {
    return _repository.logout();
  }

  final Repository _repository;
}
