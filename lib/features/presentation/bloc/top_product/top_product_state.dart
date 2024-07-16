part of 'top_product_bloc.dart';

abstract class TopProductState extends Equatable {
  const TopProductState();

  @override
  List<Object> get props => [];
}

class TopProductInitial extends TopProductState {}

class TopProductLoading extends TopProductState {}

class TopProductSuccess extends TopProductState {
  final DashBoardResponse response;

  TopProductSuccess(
    this.response,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TopProductSuccess && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;

  @override
  String toString() => 'TopProductSuccess(response: $response)';
}

class TopProductError extends TopProductState {
  final String error;

  TopProductError(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TopProductError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'TopProductError(error: $error)';
}
