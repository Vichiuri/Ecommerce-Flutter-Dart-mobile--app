part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashToLogin extends SplashState {}

class SplashToHome extends SplashState {}

class SplashToIntro extends SplashState {}

class SplashLoading extends SplashState {}

class SplashIntroLoaded extends SplashState {}

class SplashIntroErrorState extends SplashState {
  final String message;

  SplashIntroErrorState({required this.message});
}
