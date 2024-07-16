part of 'recent_bought_bloc.dart';

abstract class RecentBoughtEvent extends Equatable {
  const RecentBoughtEvent();

  @override
  List<Object> get props => [];
}

class RecentBoughtEventStarted extends RecentBoughtEvent {}

class RecentBoughtEventUpdated extends RecentBoughtEvent {}
