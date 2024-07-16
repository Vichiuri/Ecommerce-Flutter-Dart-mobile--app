part of 'on_message_bloc.dart';

abstract class OnMessageState extends Equatable {
  const OnMessageState();

  @override
  List<Object> get props => [];
}

class OnMessageInitial extends OnMessageState {}

class OnMessageSuccess extends OnMessageState {
  final NotificationResponse model;
  OnMessageSuccess({
    required this.model,
  });
  @override
  List<Object> get props => [model];
}

class OnMessageLoading extends OnMessageState {}

class OnMessageError extends OnMessageState {
  final String message;
  @override
  List<Object> get props => [message];
  OnMessageError({
    required this.message,
  });
}
