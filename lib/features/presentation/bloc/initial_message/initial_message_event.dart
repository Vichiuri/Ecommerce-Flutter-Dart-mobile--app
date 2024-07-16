part of 'initial_message_bloc.dart';

abstract class InitialMessageEvent extends Equatable {
  const InitialMessageEvent();

  @override
  List<Object> get props => [];
}

class GetInitialMessageEventStarted extends InitialMessageEvent {}
