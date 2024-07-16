part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class MainLoadedState extends MainState {
  final CartResponse cartResponse;

  MainLoadedState({required this.cartResponse});
}

class MainLoadingState extends MainState {}

class UpdateLoadingState extends MainState {}

class MainErrorState extends MainState {
  final String message;

  MainErrorState({required this.message});
}
