import '../../../core/errors/NetworkErrorHandler.dart';

//responses are basically what you get from net, if success or error
class ApiSuccessResponse {
  final String? message, error;

  ApiSuccessResponse({required this.message, this.error});

  ApiSuccessResponse.withError(String errorValue)
      : message = null,
        error = networkErrorHandler(errorValue);
}
