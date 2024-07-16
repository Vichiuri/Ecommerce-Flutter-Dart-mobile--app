import 'dart:io';

import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kLinkStyle = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kRLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  fontSize: 12,
);

final kRHintStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans',
  fontSize: 12,
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.blue.withOpacity(0.05),
  borderRadius: BorderRadius.circular(10.0),
);

const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

final kInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(
    width: 0,
    style: BorderStyle.none,
  ),
);

//*LOCAL URL
// const String RESET_PASS_URL = "http://$BASE_URL/authv/password_reset";
// const String BASE_URL = "192.168.0.24:9000";
// const String IMAGE_URL = "http://$BASE_URL";
// * Online Url
const String RESET_PASS_URL = "https://$BASE_URL/authv/password_reset";

const String BASE_URL = "scm.netbotapp.com";
const String IMAGE_URL = "https://$BASE_URL";

//*update apks
const String UPDATE_URL = "https://scm.netbotapp.com/mobile/apk/download";

//*offers scheme

//*offers scheme
const BUYXXFREE = 'BnXEX';
const BUYXYFREE = "BnXYF";
const BUYXYOFF = "BnXy%O";

//*Empty Image Url
const String EMPTY_IMAGE_URL =
    "https://images.unsplash.com/photo-1614453966327-a3f3562bf548?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fGNhcnR8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80";

const defaultDuration = Duration(milliseconds: 250);
const kPrimaryColor = Color(0xFFFF7643);
const kBlackColor = Color(0xff181818);

//*email regex
const EMAIL_REGEX =
    r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

const SAVE_USER = "SAVE_USER";
const ACCESS_TOKEN = "ACCESS_TOKEN";
const CHECK_FIRST_TIME = "CHECK_FIRST_TIME";
const SAVE_DISTRIBUTOR = "SAVE_DISTRIBUTOR";
const SAVE_SALESMAN_DISTRIBUTOR = "SAVE_SALESMAN_DISTRIBUTOR";
const SAVE_RETAILER = "SAVE_RETAILER";

//* Common Consts
const SERVER_FAILURE_MESSAGE = "Server error please try again";
const NETWORK_FAILURE_MESSAGE = "Please activate your internet";
const SOCKET_FAILURE_MESSAGE = "Seems you internet connection ran out";
const CACHE_FAILURE_MESSAGE = "Could not access records";
const INPUT_FAILURE_MESSAGE = "Input Failure";
const SELECT_FROM_PHONE_FAILURE_MESSAGE = "Something went wrong with the file";
const SELECT_FROM_GALLERY_FAILURE_MESSAGE = "Couldnt pick image from gallery";
const SELECT_FAIL_FAILURE_MESSAGE = "You did not pick an file";
const PERMISSION_FAILURE_MESSAGE =
    "Please enable locations for app in settings";
const PERMISSION_NEVER_ASKED_FAILURE_MESSAGE =
    "Error in asking location permissions, Please try agai";
const ACCOUNT_FAILURE_MESSAGE = "Could not create an account";
const UNAUTHENTICATED_FAILURE_MESSAGE =
    "You are unauthenticated, you will be logged out";
const SERVER_MAINTAINCE_FAILURE_MESSAGE = "Service maintenance failed";
const LANGUAGE_FAILURE_MESSAGE = "Could not fetch locale";
const FORBIDDEN_MESSAGE = "Access to the requested resource is forbidden";
const NOT_FOUND_MESSAGE = "Method not found";

const CACHE_AUTH_TOKEN = "CACHE_AUTH_TOKEN";
const CACHE_DASH_BOARD_DATA = "CACHE_DASH_BOARD_DATA";
const CHECK_SAVED_USER = "CHECK_SAVED_USER";
const AUTH_USER = 'AUTH_USER';
const SELECT_FROM_CAMERA_FAILURE_MESSAGE =
    "Something went wrong with the camera";

const SELECT_IMAGE_FAILURE_MESSAGE = "You did not pick an image";
const DATABASE_FAILURE = "Database Failure";
const LOCATION_ERROR = "Failed to fetch location services";

//exeption checketer
String returnFailure(final exception) {
  if (exception is ServerException) {
    return SERVER_FAILURE_MESSAGE;
  } else if (exception is CacheException) {
    return CACHE_FAILURE_MESSAGE;
  } else if (exception is UnAuthenticatedException) {
    return UNAUTHENTICATED_FAILURE_MESSAGE;
  } else if (exception is SelectFileException) {
    return SELECT_FAIL_FAILURE_MESSAGE;
  } else if (exception is SelectFileFromPhoneExeption) {
    return SELECT_FROM_PHONE_FAILURE_MESSAGE;
  } else if (exception is SelectImageFromGalleryException) {
    return SELECT_FROM_GALLERY_FAILURE_MESSAGE;
  } else if (exception is AccountCreationException) {
    return ACCOUNT_FAILURE_MESSAGE;
  } else if (exception is PermissionException) {
    return PERMISSION_FAILURE_MESSAGE;
  } else if (exception is PermissionNeverAskedException) {
    return PERMISSION_NEVER_ASKED_FAILURE_MESSAGE;
  } else if (exception is NetworkInfoException) {
    return NETWORK_FAILURE_MESSAGE;
  } else if (exception is ServerMaintainException) {
    return SERVER_MAINTAINCE_FAILURE_MESSAGE;
  } else if (exception is SocketException) {
    return SOCKET_FAILURE_MESSAGE;
  } else if (exception is LanguageExeption) {
    return LANGUAGE_FAILURE_MESSAGE;
  } else if (exception is NotFoundExeption) {
    return NOT_FOUND_MESSAGE;
  } else if (exception is SelectImageException) {
    return SELECT_IMAGE_FAILURE_MESSAGE;
  } else if (exception is SelectImageFromCameraException) {
    return SELECT_FROM_CAMERA_FAILURE_MESSAGE;
  } else if (exception is SelectImageFromGalleryException) {
    return SELECT_FROM_GALLERY_FAILURE_MESSAGE;
  } else if (exception is DatabaseExeption) {
    return DATABASE_FAILURE;
  } else if (exception is LocationServiceExeption) {
    return LOCATION_ERROR;
  } else {
    return SERVER_FAILURE_MESSAGE;
  }
}
