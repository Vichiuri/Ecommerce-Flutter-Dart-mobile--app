import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/banners/BannerModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_banners.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'get_banners_event.dart';
part 'get_banners_state.dart';

@injectable
class GetBannersBloc extends Bloc<GetBannersEvent, GetBannersState> {
  GetBannersBloc(this._banners) : super(GetBannersInitial());
  final GetBanners _banners;

  @override
  Stream<GetBannersState> mapEventToState(
    GetBannersEvent event,
  ) async* {
    if (event is GetBannerStated) {
      yield GetBannersLoading();
      final _res = await _banners.call(ParamsIdNullable(id: event.page));
      yield _res.fold(
        (l) => GetBannersError(message: l),
        (r) => GetBannersSuccess(banners: r.banners),
      );
    }
    if (event is GetBannerUpdate) {
      yield GetBannersUpdating();
      final _res = await _banners.call(ParamsIdNullable(id: event.page ?? 0));
      yield _res.fold(
        (l) => GetBannersError(message: l),
        (r) => GetBannersSuccess(banners: r.banners),
      );
    }
  }
}
