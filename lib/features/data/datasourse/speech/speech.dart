import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

abstract class SpeechSource {
  Stream<String> listenToSPeech();
  stopSpeech();
}

@LazySingleton(as: SpeechSource)
class SpeechSourceImpl implements SpeechSource {
  final stt.SpeechToText _speechToText;

  SpeechSourceImpl(this._speechToText);

  @override
  Stream<String> listenToSPeech() async* {
    final _isAvail = await _speechToText.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (_isAvail) {
      yield* _speechToText
          .listen(onResult: (result) => result.recognizedWords)
          .asStream()
          .map((event) => event);
    }
    throw Exception();
  }

  @override
  stopSpeech() {
    return _speechToText.stop();
  }
}
