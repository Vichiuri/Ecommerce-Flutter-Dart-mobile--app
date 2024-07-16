part of 'get_retailer_bloc.dart';

abstract class GetRetailerEvent extends Equatable {
  const GetRetailerEvent();

  @override
  List<Object> get props => [];
}

class GetRetailerStarted extends GetRetailerEvent {}
