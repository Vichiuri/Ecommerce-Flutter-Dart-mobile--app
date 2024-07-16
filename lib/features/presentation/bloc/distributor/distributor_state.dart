part of 'distributor_bloc.dart';

abstract class DistributorState extends Equatable {
  const DistributorState();

  @override
  List<Object> get props => [];
}

class DistributorInitial extends DistributorState {}

class ChangeDistributorLoading extends DistributorState {}

class UpdateDistributorLoading extends DistributorState {}

class DistributorSuccess extends DistributorState {
  final DistributorResponse response;

  DistributorSuccess({
    required this.response,
  });
  @override
  List<Object> get props => [response];
}

class ChangeDistributorSuccess extends DistributorState {
  final String response;

  ChangeDistributorSuccess({
    required this.response,
  });
  @override
  List<Object> get props => [response];
}

class DistributorError extends DistributorState {
  final String message;
  DistributorError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class DistributorLoading extends DistributorState {}
