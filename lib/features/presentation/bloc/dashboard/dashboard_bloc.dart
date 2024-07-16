import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../data/responses/DashBoardResponse.dart';
import '../../../domain/usecase/FetchDashBoard.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({required this.fetchDashBoard}) : super(DashboardInitial());

  final FetchDashBoard fetchDashBoard;

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
    //TODO hapa
  ) async* {
    if (event is FetchDashBoardEvent) {
      yield DashBoardLoading();
      final dashBoardEither = await fetchDashBoard(NoParams());
      yield* dashBoardEither.fold(
        (failure) async* {
          print(failure);
          yield DashBoardErrorState(message: failure);
        },
        (response) async* {
          yield DashBoardLoaded(response: response);
        },
      );
    }
    if (event is UpdateDashBoardEvent) {
      final dashBoardEither = await fetchDashBoard(NoParams());
      yield* dashBoardEither.fold(
        (failure) async* {
          print(failure);
          yield DashBoardErrorState(message: failure);
        },
        (response) async* {
          yield DashBoardLoaded(response: response);
        },
      );
    }
  }
}
