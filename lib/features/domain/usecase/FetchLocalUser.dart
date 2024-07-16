import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/usecase/usecase.dart';
import '../models/retailers/RetailerModel.dart';
import '../repositories/repository.dart';

@lazySingleton
class FetchLocalUser extends UseCase<RetailerModel, NoParams> {
  final Repository repository;
  FetchLocalUser({required this.repository});
  @override
  Future<Either<String, RetailerModel>> call(NoParams params) {
    return repository.fetchLocalUser();
  }
}
