part of 'get_banners_bloc.dart';

abstract class GetBannersEvent extends Equatable {
  const GetBannersEvent();

  @override
  List<Object> get props => [];
}

class GetBannerStated extends GetBannersEvent {
  final int? page;
  GetBannerStated({
    this.page,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetBannerStated && other.page == page;
  }

  @override
  int get hashCode => page.hashCode;
}

class GetBannerUpdate extends GetBannersEvent {
  final int? page;
  GetBannerUpdate({
    this.page,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetBannerUpdate && other.page == page;
  }

  @override
  int get hashCode => page.hashCode;
}
