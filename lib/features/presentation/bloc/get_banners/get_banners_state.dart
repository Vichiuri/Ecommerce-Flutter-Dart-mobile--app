part of 'get_banners_bloc.dart';

abstract class GetBannersState extends Equatable {
  const GetBannersState();

  @override
  List<Object> get props => [];
}

class GetBannersInitial extends GetBannersState {}

class GetBannersSuccess extends GetBannersState {
  final List<BannerModel> banners;
  GetBannersSuccess({
    required this.banners,
  });
  @override
  List<Object> get props => [banners];
}

class GetBannersError extends GetBannersState {
  final String message;
  GetBannersError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class GetBannersLoading extends GetBannersState {}

class GetBannersUpdating extends GetBannersState {}
