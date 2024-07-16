import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../features/data/datasourse/local/local_data_source.dart';
import '../errors/exeptions.dart';
import '../utils/constants.dart';

@lazySingleton
class HandleNetworkCall {
  final LocalDataSource localDataSource;

  HandleNetworkCall({required this.localDataSource});

  bool checkStatusCode(int responseStatus) {
    if (responseStatus == 200) {
      return true;
    } else if (responseStatus == 401) {
      throw UnAuthenticatedException();
    } else if (responseStatus == 500) {
      throw ServerException();
    } else if (responseStatus == 503) {
      throw ServerMaintainException();
    } else if (responseStatus == 504) {
      throw SocketException("Check Your Connection");
    } else if (responseStatus == 403) {
      throw ForbiddenExeption();
    } else {
      return false;
    }
  }

  Future<String> authToken() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        return 'Token ${token.token}';
      } else {
        throw UnAuthenticatedException();
      }
    } catch (e) {
      rethrow;
    }
  }

//exeption checketer
}
