import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveFirstTime extends UseCase<bool, NoParams> {
  final Repository repository;
  SaveFirstTime({required this.repository});
  @override
  Future<Either<String, bool>> call(NoParams params) {
    return repository.saveFirstTime();
  }
}
