part of 'on_message_bloc.dart';

abstract class OnMessageEvent extends Equatable {
  const OnMessageEvent();

  @override
  List<Object> get props => [];
}

class OnMessageStarted extends OnMessageEvent {}

class OnMessageReceived extends OnMessageEvent {
  final Either<String, NotificationResponse>? notsReceived;

  OnMessageReceived({
    required this.notsReceived,
  });

  @override
  List<Object> get props => [notsReceived ?? ""];
}
