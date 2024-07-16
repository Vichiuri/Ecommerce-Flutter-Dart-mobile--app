part of 'on_message_opened_bloc.dart';

abstract class OnMessageOpenedEvent extends Equatable {
  const OnMessageOpenedEvent();

  @override
  List<Object> get props => [];
}

class OnMessageOppenedStarted extends OnMessageOpenedEvent {}

class OnMessageOppenedReceived extends OnMessageOpenedEvent {
  final Either<String, NotificationResponse>? notsReceived;

  OnMessageOppenedReceived({
    required this.notsReceived,
  });
  @override
  List<Object> get props => [notsReceived ?? ""];
}
