import 'package:injectable/injectable.dart';

import '../../../core/usecase/usecase.dart';
import '../repositories/repository.dart';

@lazySingleton
class CheckFirstTime {
  final Repository repository;
  CheckFirstTime({required this.repository});
  Future<bool> call(NoParams params) {
    return repository.checkFirstTime();
  }
}
