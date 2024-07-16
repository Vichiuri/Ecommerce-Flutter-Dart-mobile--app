part of 'initialize_product_bloc.dart';

abstract class InitializeProductState extends Equatable {
  const InitializeProductState();

  @override
  List<Object> get props => [];
}

class InitializeProductInitial extends InitializeProductState {}

class InitializeProductLoading extends InitializeProductState {}

class InitializeProductSuccess extends InitializeProductState {
  final int? currentPage;
  final int? lastPage;
  InitializeProductSuccess({
    required this.currentPage,
    required this.lastPage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InitializeProductSuccess &&
        other.currentPage == currentPage &&
        other.lastPage == lastPage;
  }

  @override
  int get hashCode => currentPage.hashCode ^ lastPage.hashCode;
}

class InitializeProductError extends InitializeProductState {
  final String error;
  InitializeProductError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
