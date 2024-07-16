part of 'description_bloc.dart';

abstract class DescriptionState extends Equatable {
  const DescriptionState();

  @override
  List<Object> get props => [];
}

class DescriptionInitial extends DescriptionState {}

class DescriptionLoading extends DescriptionState {}

class DescriptionError extends DescriptionState {
  final String error;
  DescriptionError({
    required this.error,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DescriptionError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

class DescriptionSuccess extends DescriptionState {
  final String desc;
  DescriptionSuccess({
    required this.desc,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DescriptionSuccess && other.desc == desc;
  }

  @override
  int get hashCode => desc.hashCode;
}
