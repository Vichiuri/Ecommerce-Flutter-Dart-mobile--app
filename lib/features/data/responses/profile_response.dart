import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import 'package:biz_mobile_app/features/domain/models/profile/profile.dart';

class ProfileResponse {
  final ProfileModel? profile;
  final String? success;
  final String? error;

  ProfileResponse({
    required this.profile,
    required this.success,
    this.error,
  });

  ProfileResponse.withError(String error)
      : error = networkErrorHandler(error),
        success = null,
        profile = null;
}
