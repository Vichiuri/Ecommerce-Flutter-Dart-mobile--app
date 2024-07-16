import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/domain/usecase/fetch_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(this._notifications) : super(NotificationsInitial());
  final FetchNotifications _notifications;

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is GetNotificationStarted) {
      yield NotificationsLoading();
      final _res = await _notifications.call(NoParams());
      yield _res.fold(
        (l) => NotificationsError(message: l),
        (r) => NotificationsSuccess(response: r),
      );
    }
    if (event is GetNotificationUpdated) {
      // yield NotificationsLoading();
      final _res = await _notifications.call(NoParams());
      yield _res.fold(
        (l) => NotificationsError(message: l),
        (r) => NotificationsSuccess(response: r),
      );
    }
  }
}
