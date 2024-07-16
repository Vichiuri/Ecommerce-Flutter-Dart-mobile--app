import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/profile_response.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchProfile extends UseCase<ProfileResponse, NoParams> {
  FetchProfile(this._repository);

  @override
  Future<Either<String, ProfileResponse>> call(NoParams params) {
    return _repository.fetchProfile();
  }

  final Repository _repository;
}
