part of 'initial_message_bloc.dart';

abstract class InitialMessageState extends Equatable {
  const InitialMessageState();

  @override
  List<Object> get props => [];
}

class InitialMessageInitial extends InitialMessageState {}

class InitialMessageLoading extends InitialMessageState {}

class InitialMessageSuccess extends InitialMessageState {
  @override
  List<Object> get props => [model];

  final NotificationResponse model;

  InitialMessageSuccess({
    required this.model,
  });
}

class InitialMessageError extends InitialMessageState {
  final String message;
  InitialMessageError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
