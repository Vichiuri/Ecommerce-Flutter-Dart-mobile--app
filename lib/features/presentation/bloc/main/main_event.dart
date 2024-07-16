part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class FetchCartEvent extends MainEvent {}

class UpdateCartEvent extends MainEvent {}
