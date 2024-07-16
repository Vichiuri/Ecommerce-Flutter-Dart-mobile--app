import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/domain/models/notification/notification_model.dart';
import 'package:biz_mobile_app/features/domain/usecase/stream_on_message_opened_app.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'on_message_opened_event.dart';
part 'on_message_opened_state.dart';

@injectable
class OnMessageOpenedBloc
    extends Bloc<OnMessageOpenedEvent, OnMessageOpenedState> {
  OnMessageOpenedBloc(this._stream) : super(OnMessageOpenedInitial());
  final StreamOnMessageOpenedApp _stream;

  @override
  Future<void> close() async {
    await _netSubscription?.cancel();
    return super.close();
  }

  StreamSubscription<Either<String, NotificationResponse>?>? _netSubscription;

  @override
  Stream<OnMessageOpenedState> mapEventToState(
    OnMessageOpenedEvent event,
  ) async* {
    if (event is OnMessageOppenedStarted) {
      await _netSubscription?.cancel();
      _netSubscription = _stream.call(NoParams()).listen(
          (message) => add(OnMessageOppenedReceived(notsReceived: message)));
    }
    if (event is OnMessageOppenedReceived) {
      yield OnMessageOpenedLoading();
      if (event.notsReceived != null) {
        yield event.notsReceived!.fold(
          (l) => OnMessageOpenedError(message: l),
          (r) => OnMessageOpenedSuccess(model: r),
        );
      } else {
        yield OnMessageOpenedError(message: "No Nots");
      }
    }
  }
}
