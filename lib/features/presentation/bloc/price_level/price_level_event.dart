part of 'price_level_bloc.dart';

abstract class PriceLevelEvent extends Equatable {
  const PriceLevelEvent();

  @override
  List<Object> get props => [];
}

class GetPriceLevelEvent extends PriceLevelEvent {
  final int prodId;
  final int qty;
  final String price;
  GetPriceLevelEvent({
    required this.prodId,
    required this.qty,
    required this.price,
  });
  @override
  List<Object> get props => [prodId, qty];
}
