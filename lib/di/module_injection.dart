// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

//*this is for injecting third party libraries
@module
abstract class InjectionModules {
  //*shared preferences for cache storage
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  //*check connectivity of the phone
  // @lazySingleton
  // Connectivity get connectivity => Connectivity();

  //*firebase messaging
  @lazySingleton
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  //*location
  @lazySingleton
  Location get location => Location.instance;

  //*picking files
  // @lazySingleton
  // FilePicker get filePicker => FilePicker.platform;

  //*Speech Recognition
  stt.SpeechToText get speech => stt.SpeechToText();

  // //*picking images
  // @lazySingleton
  // ImagePicker get imagePicker => ImagePicker();

}
