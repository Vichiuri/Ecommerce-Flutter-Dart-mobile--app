import 'dart:async';

import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/notification/notification_model.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_initial_message.dart';

part 'initial_message_event.dart';
part 'initial_message_state.dart';

@injectable
class InitialMessageBloc
    extends Bloc<InitialMessageEvent, InitialMessageState> {
  InitialMessageBloc(this._message) : super(InitialMessageInitial());
  final GetInitialMessage _message;

  @override
  Stream<InitialMessageState> mapEventToState(
    InitialMessageEvent event,
  ) async* {
    if (event is GetInitialMessageEventStarted) {
      yield InitialMessageLoading();
      final _res = await _message.call(NoParams());
      yield* _res.fold(
        (l) async* {
          yield InitialMessageError(message: l);
        },
        (r) async* {
          if (r != null) {
            yield InitialMessageSuccess(model: r);
          }
          yield InitialMessageError(message: "no nots");
        },
      );
    }
  }
}
