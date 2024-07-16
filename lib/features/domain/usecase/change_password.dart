import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangePassword extends UseCase<String, ChangePasswordParams> {
  ChangePassword(this._repository);

  @override
  Future<Either<String, String>> call(ChangePasswordParams params) {
    return _repository.changePassword(
        oldPass: params.oldPass, newPass: params.newPass);
  }

  final Repository _repository;
}

class ChangePasswordParams {
  final String oldPass;
  final String newPass;
  ChangePasswordParams({
    required this.oldPass,
    required this.newPass,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChangePasswordParams &&
        other.oldPass == oldPass &&
        other.newPass == newPass;
  }

  @override
  int get hashCode => oldPass.hashCode ^ newPass.hashCode;

  @override
  String toString() =>
      'ChangePasswordParams(oldPass: $oldPass, newPass: $newPass)';
}
