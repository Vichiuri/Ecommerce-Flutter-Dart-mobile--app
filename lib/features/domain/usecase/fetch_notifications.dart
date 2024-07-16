import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchNotifications extends UseCase<NotificationResponse, NoParams> {
  FetchNotifications(this._repository);

  @override
  Future<Either<String, NotificationResponse>> call(NoParams params) {
    return _repository.fetchNotifictains();
  }

  final Repository _repository;
}
