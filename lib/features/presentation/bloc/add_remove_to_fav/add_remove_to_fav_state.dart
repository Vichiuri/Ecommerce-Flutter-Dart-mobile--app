part of 'add_remove_to_fav_bloc.dart';

abstract class AddRemoveToFavState extends Equatable {
  const AddRemoveToFavState();

  @override
  List<Object> get props => [];
}

class AddRemoveToFavInitial extends AddRemoveToFavState {}

class AddRemoveToFavLoading extends AddRemoveToFavState {}

class AddRemoveToFavSuccess extends AddRemoveToFavState {
  final String message;
  final int id;

  AddRemoveToFavSuccess({
    required this.message,
    required this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddRemoveToFavSuccess &&
        other.message == message &&
        other.id == id;
  }

  @override
  int get hashCode => message.hashCode ^ id.hashCode;
}

class AddRemoveToFavError extends AddRemoveToFavState {
  final String message;

  AddRemoveToFavError({
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddRemoveToFavError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
