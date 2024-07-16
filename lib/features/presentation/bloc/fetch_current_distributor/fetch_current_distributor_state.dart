part of 'fetch_current_distributor_bloc.dart';

abstract class FetchCurrentDistributorState extends Equatable {
  const FetchCurrentDistributorState();

  @override
  List<Object> get props => [];
}

class FetchCurrentDistributorInitial extends FetchCurrentDistributorState {}

class FetchCurrentDistributorLoading extends FetchCurrentDistributorState {}

class FetchCurrentDistributorSuccess extends FetchCurrentDistributorState {
  final DistributorsModel? distributor;
  final RetailerModel? retailerModel;

  FetchCurrentDistributorSuccess({
    required this.distributor,
    required this.retailerModel,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchCurrentDistributorSuccess &&
        other.distributor == distributor &&
        other.retailerModel == retailerModel;
  }

  @override
  int get hashCode => distributor.hashCode ^ retailerModel.hashCode;
}

class FetchCurrentDistributorError extends FetchCurrentDistributorState {
  final String message;
  FetchCurrentDistributorError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
