part of 'initialize_product_bloc.dart';

abstract class InitializeProductEvent extends Equatable {
  const InitializeProductEvent();

  @override
  List<Object> get props => [];
}

class InitializeProductStarted extends InitializeProductEvent {
  final int? page;

  InitializeProductStarted(this.page);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InitializeProductStarted && other.page == page;
  }

  @override
  int get hashCode => page.hashCode;

  @override
  String toString() => 'InitializeProductStarted(page: $page)';
}
