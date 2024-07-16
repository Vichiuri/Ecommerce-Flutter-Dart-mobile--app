// import 'dart:async';

// import 'package:biz_mobile_app/core/usecase/usecase.dart';
// import 'package:biz_mobile_app/features/domain/usecase/check_connection.dart';
// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:injectable/injectable.dart';

// part 'network_event.dart';
// part 'network_state.dart';

// @injectable
// class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
//   NetworkBloc(this._checkConnection) : super(NetworkInitial());
//   final CheckConnection _checkConnection;

//   @override
//   Future<void> close() async {
//     await _netSubscription?.cancel();
//     return super.close();
//   }

//   StreamSubscription<Either<String, bool>>? _netSubscription;

//   @override
//   Stream<NetworkState> mapEventToState(
//     NetworkEvent event,
//   ) async* {
//     if (event is NetworkStarted) {
//       await _netSubscription?.cancel();
//       _netSubscription = _checkConnection
//           .call(NoParams())
//           .listen((network) => add(NetworkReceived(network: network)));
//     } else if (event is NetworkReceived) {
//       yield NetworkLoading();
//       yield event.network.fold(
//         (failure) => NetworkError(message: failure),
//         (connected) => NetworkSuccess(connected: connected),
//       );
//     }
//   }
// }
