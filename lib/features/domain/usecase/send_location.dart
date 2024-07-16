import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SendLocation extends UseCase<String, NoParams> {
  final Repository _repository;

  SendLocation(this._repository);

  @override
  Future<Either<String, String>> call(NoParams params) {
    return _repository.sendLocation();
  }
}
