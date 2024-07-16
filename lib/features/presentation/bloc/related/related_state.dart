part of 'related_bloc.dart';

abstract class RelatedState extends Equatable {
  const RelatedState();

  @override
  List<Object> get props => [];
}

class RelatedInitial extends RelatedState {}

class RelatedLoading extends RelatedState {}

class RelatedError extends RelatedState {
  final String error;
  RelatedError({
    required this.error,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RelatedError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

class RelatedSuccess extends RelatedState {
  final List<ProductModel> related;
  RelatedSuccess({
    required this.related,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RelatedSuccess && listEquals(other.related, related);
  }

  @override
  int get hashCode => related.hashCode;
}
