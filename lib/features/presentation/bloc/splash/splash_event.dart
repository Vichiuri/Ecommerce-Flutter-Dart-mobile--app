part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class CheckFirstTimeEvent extends SplashEvent {}

class SaveFirstTimeEvent extends SplashEvent {}

class LogoutEvent extends SplashEvent {}
