part of 'slabs_bloc.dart';

abstract class SlabsState extends Equatable {
  const SlabsState();

  @override
  List<Object> get props => [];
}

class SlabsInitial extends SlabsState {}

class SlabsLoading extends SlabsState {}

class SlabsSuccess extends SlabsState {
  final List<SlabsModel> slabs;
  SlabsSuccess({
    required this.slabs,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SlabsSuccess && listEquals(other.slabs, slabs);
  }

  @override
  int get hashCode => slabs.hashCode;
}

class SlabsError extends SlabsState {
  final String error;
  SlabsError({
    required this.error,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SlabsError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
