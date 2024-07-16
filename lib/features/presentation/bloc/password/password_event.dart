part of 'password_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordEventStarted extends PasswordEvent {
  final String oldPass;
  final String newPass;
  ChangePasswordEventStarted({
    required this.oldPass,
    required this.newPass,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChangePasswordEventStarted &&
        other.oldPass == oldPass &&
        other.newPass == newPass;
  }

  @override
  int get hashCode => oldPass.hashCode ^ newPass.hashCode;

  @override
  String toString() =>
      'ChangePasswordEventStarted(oldPass: $oldPass, newPass: $newPass)';
}
