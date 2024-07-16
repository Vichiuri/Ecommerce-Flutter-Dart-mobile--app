import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/domain/models/notification/notification_model.dart';
import 'package:biz_mobile_app/features/domain/usecase/stream_on_message.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'on_message_event.dart';
part 'on_message_state.dart';

@injectable
class OnMessageBloc extends Bloc<OnMessageEvent, OnMessageState> {
  OnMessageBloc(this._onMessage) : super(OnMessageInitial());
  final StreamOnMessage _onMessage;

  @override
  Future<void> close() async {
    await _netSubscription?.cancel();
    return super.close();
  }

  StreamSubscription<Either<String, NotificationResponse>?>? _netSubscription;
  @override
  Stream<OnMessageState> mapEventToState(
    OnMessageEvent event,
  ) async* {
    if (event is OnMessageStarted) {
      await _netSubscription?.cancel();
      _netSubscription = _onMessage
          .call(NoParams())
          .listen((message) => add(OnMessageReceived(notsReceived: message)));
    }
    if (event is OnMessageReceived) {
      yield OnMessageLoading();
      if (event.notsReceived != null) {
        yield* event.notsReceived!.fold(
          (l) async* {
            yield OnMessageError(message: l);
          },
          (r) async* {
            yield OnMessageSuccess(model: r);
          },
        );
      } else {
        yield OnMessageError(message: "No Nots");
      }
    }
  }
}
