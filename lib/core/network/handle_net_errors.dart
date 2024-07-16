import 'dart:convert';

String networkError(String errorValue) {
  String value = "";
  if (jsonDecode(errorValue)['errors'] != null) {
    Map<String, dynamic> errors = jsonDecode(errorValue)['errors'];
    final error = errors.values.first;
    if (!(error is String) && error.length > 0) {
      value = error[0];
    } else {
      value = error;
    }
  } else if (jsonDecode(errorValue)["message"] != null) {
    value = jsonDecode(errorValue)["message"];
  } else {
    value = jsonDecode(errorValue)["error"];
  }
  return value;
}
