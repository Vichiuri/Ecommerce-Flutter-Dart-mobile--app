part of 'on_message_opened_bloc.dart';

abstract class OnMessageOpenedState extends Equatable {
  const OnMessageOpenedState();

  @override
  List<Object> get props => [];
}

class OnMessageOpenedInitial extends OnMessageOpenedState {}

class OnMessageOpenedLoading extends OnMessageOpenedState {}

class OnMessageOpenedSuccess extends OnMessageOpenedState {
  final NotificationResponse model;
  OnMessageOpenedSuccess({
    required this.model,
  });
  @override
  List<Object> get props => [model];
}

class OnMessageOpenedError extends OnMessageOpenedState {
  final String message;
  OnMessageOpenedError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
