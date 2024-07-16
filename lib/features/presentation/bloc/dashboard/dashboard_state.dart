part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashBoardLoading extends DashboardState {}

class DashBoardLoaded extends DashboardState {
  final DashBoardResponse response;

  DashBoardLoaded({required this.response});
  @override
  List<Object> get props => [response];
}

class DashBoardErrorState extends DashboardState {
  final String message;

  DashBoardErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
