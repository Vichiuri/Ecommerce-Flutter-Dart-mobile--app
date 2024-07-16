part of 'fetch_current_distributor_bloc.dart';

abstract class FetchCurrentDistributorEvent extends Equatable {
  const FetchCurrentDistributorEvent();

  @override
  List<Object> get props => [];
}

class FetchCurrentStarted extends FetchCurrentDistributorEvent {}
