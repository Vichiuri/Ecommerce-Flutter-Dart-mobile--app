part of 'single_product_bloc.dart';

abstract class SingleProductEvent extends Equatable {
  const SingleProductEvent();

  @override
  List<Object> get props => [];
}

class GetSingleProductStarted extends SingleProductEvent {
  final int productId;
  GetSingleProductStarted({
    required this.productId,
  });
  @override
  List<Object> get props => [productId];
}

class UpdateSingleProductStarted extends SingleProductEvent {
  final int productId;
  UpdateSingleProductStarted({
    required this.productId,
  });
  @override
  List<Object> get props => [productId];
}
