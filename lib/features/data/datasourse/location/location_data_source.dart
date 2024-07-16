import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

abstract class LocationDataSource {
  Future<LocationData> getUserLocation();
  Stream<LocationData> watchUserLocation();
}

@LazySingleton(as: LocationDataSource)
class LocationSource implements LocationDataSource {
  final Location _location;

  LocationSource(this._location);
  @override
  Future<LocationData> getUserLocation() async {
    final _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      await _location
          .requestService()
          .then((value) => {
                if (!value) {throw PermissionException()}
              })
          .onError(
              (error, stackTrace) => throw PermissionNeverAskedException());
    }
    return _location
        .getLocation()
        .then((data) => data)
        .onError((error, stackTrace) => throw LocationServiceExeption());
  }

  @override
  Stream<LocationData> watchUserLocation() async* {
    final _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      await _location
          .requestService()
          .then((value) => {
                if (!value) {throw PermissionException()}
              })
          .onError(
              (error, stackTrace) => throw PermissionNeverAskedException());
    }
    yield* _location.onLocationChanged
        .map((data) => data)
        .onErrorReturnWith((error, stackTrace) {
      print("$error, $stackTrace");
      throw LocationServiceExeption();
    });
  }
}
