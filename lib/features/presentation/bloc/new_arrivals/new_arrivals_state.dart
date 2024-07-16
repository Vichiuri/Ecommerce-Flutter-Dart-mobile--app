part of 'new_arrivals_bloc.dart';

abstract class NewArrivalsState extends Equatable {
  const NewArrivalsState();

  @override
  List<Object> get props => [];
}

class NewArrivalsInitial extends NewArrivalsState {}

class NewArrivalsLoading extends NewArrivalsState {
  final String message;
  NewArrivalsLoading({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class NewArrivalsUpdating extends NewArrivalsState {}

class NewArrivalsSuccess extends NewArrivalsState {
  @override
  List<Object> get props => [response];
  final DashBoardResponse response;
  final double position;
  final List<ProductModel> products;
  NewArrivalsSuccess(
      {required this.response, required this.position, required this.products});
}

class NewArrivalsError extends NewArrivalsState {
  @override
  List<Object> get props => [position, error];
  final double position;
  final String error;
  NewArrivalsError({
    required this.position,
    required this.error,
  });
}
