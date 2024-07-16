import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ForgotPassword extends UseCase<String, ParamsString> {
  ForgotPassword(this._repository);

  @override
  Future<Either<String, String>> call(ParamsString params) {
    return _repository.forgotPassword(email: params.string);
  }

  final Repository _repository;
}
