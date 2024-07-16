part of 'top_product_bloc.dart';

abstract class TopProductEvent extends Equatable {
  const TopProductEvent();

  @override
  List<Object> get props => [];
}

class TopProductStarted extends TopProductEvent {}

class TopProductUpdate extends TopProductEvent {}
