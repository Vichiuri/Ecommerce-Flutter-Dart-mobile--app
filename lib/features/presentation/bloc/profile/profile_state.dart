part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'ProfileError(message: $message)';
}

class ProfileSuccess extends ProfileState {
  final ProfileResponse profile;
  ProfileSuccess({
    required this.profile,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileSuccess && other.profile == profile;
  }

  @override
  int get hashCode => profile.hashCode;

  @override
  String toString() => 'ProfileSuccess(profile: $profile)';
}
