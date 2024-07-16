import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/usecase/usecase.dart';
import '../../data/responses/DashBoardResponse.dart';
import '../repositories/repository.dart';

@lazySingleton
class FetchDashBoard extends UseCase<DashBoardResponse, NoParams> {
  final Repository repository;

  FetchDashBoard({required this.repository});

  @override
  Future<Either<String, DashBoardResponse>> call(NoParams params) {
    return repository.fetchDashBoardResponse();
  }
}
