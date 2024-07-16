part of 'price_level_bloc.dart';

abstract class PriceLevelState extends Equatable {
  const PriceLevelState();

  @override
  List<Object> get props => [];
}

class PriceLevelInitial extends PriceLevelState {}

class PriceLevelLoading extends PriceLevelState {}

class PriceLevelSuccess extends PriceLevelState {
  final String price;
  PriceLevelSuccess({
    required this.price,
  });
  @override
  List<Object> get props => [price];
}
// class PriceLevelLoading extends PriceLevelState {}
