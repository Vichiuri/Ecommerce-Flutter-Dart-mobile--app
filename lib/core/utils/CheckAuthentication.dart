import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CheckAuthentication {
  Either<List, bool> checkLoginAuthentication(
      String username, String password) {
    if (username.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(username)) {
      return Left(["username", "Please input email"]);
    } else if (password.length < 6 || password.isEmpty) {
      return Left(["password", "Please input correct password format"]);
    } else {
      return Right(true);
    }
  }
}

//*VALIDATORS