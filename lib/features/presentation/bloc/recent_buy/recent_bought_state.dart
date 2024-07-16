part of 'recent_bought_bloc.dart';

abstract class RecentBoughtState extends Equatable {
  const RecentBoughtState();

  @override
  List<Object> get props => [];
}

class RecentBoughtInitial extends RecentBoughtState {}

class RecentBoughtLoading extends RecentBoughtState {}

class RecentBoughtSuccess extends RecentBoughtState {
  final DashBoardResponse response;

  RecentBoughtSuccess(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecentBoughtSuccess && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;

  @override
  String toString() => 'RecentBoughtSuccess(response: $response)';
}

class RecentBoughtError extends RecentBoughtState {
  final String message;

  RecentBoughtError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecentBoughtError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'RecentBoughtError(message: $message)';
}
