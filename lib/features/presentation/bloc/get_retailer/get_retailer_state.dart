part of 'get_retailer_bloc.dart';

abstract class GetRetailerState extends Equatable {
  const GetRetailerState();

  @override
  List<Object> get props => [];
}

class GetRetailerInitial extends GetRetailerState {}

class GetRetailerLoading extends GetRetailerState {}

class GetRetailerSuccess extends GetRetailerState {
  final RetailerModel retailer;

  GetRetailerSuccess({
    required this.retailer,
  });
}

class GetRetailerError extends GetRetailerState {
  final String error;
  GetRetailerError({
    required this.error,
  });
}
