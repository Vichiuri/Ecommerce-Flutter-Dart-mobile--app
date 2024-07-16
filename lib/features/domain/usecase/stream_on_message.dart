import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/domain/models/notification/notification_model.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StreamOnMessage
    extends StreamUseCaseNullable<NotificationResponse, NoParams> {
  StreamOnMessage(this._repository);

  @override
  Stream<Either<String, NotificationResponse>?> call(NoParams params) {
    return _repository.streamOnMessage();
  }

  final Repository _repository;
}
