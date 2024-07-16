part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final NotificationResponse response;
  NotificationsSuccess({
    required this.response,
  });
  @override
  List<Object> get props => [response];
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
