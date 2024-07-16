import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/domain/models/notification/notification_model.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetInitialMessage extends UseCase<NotificationResponse?, NoParams> {
  GetInitialMessage(this._repository);

  @override
  Future<Either<String, NotificationResponse?>> call(NoParams params) {
    return _repository.getInitialMessage();
  }

  final Repository _repository;
}
