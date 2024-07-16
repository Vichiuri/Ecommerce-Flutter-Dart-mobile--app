part of 'add_remove_to_fav_bloc.dart';

abstract class AddRemoveToFavEvent extends Equatable {
  const AddRemoveToFavEvent();

  @override
  List<Object> get props => [];
}

class AddRemoveToFavPressed extends AddRemoveToFavEvent {
  final int prodId;
  AddRemoveToFavPressed({
    required this.prodId,
  });

  @override
  List<Object> get props => [prodId];
}
