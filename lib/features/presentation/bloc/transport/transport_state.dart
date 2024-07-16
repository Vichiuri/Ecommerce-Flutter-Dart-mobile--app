part of 'transport_bloc.dart';

abstract class TransportState extends Equatable {
  const TransportState();

  @override
  List<Object> get props => [];
}

class TransportInitial extends TransportState {}

class TransportLoading extends TransportState {}

class TransportSuccess extends TransportState {
  final TransportResponse response;
  TransportSuccess({
    required this.response,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransportSuccess && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;

  @override
  String toString() => 'TransportSuccess(response: $response)';
}

class TransportError extends TransportState {
  final String error;
  TransportError({
    required this.error,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransportError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'TransportError(error: $error)';
}
