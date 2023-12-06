// const int _limitRetry = 3;

class SpeechTextService {
  // late SpeechToText _speech;
  // final bool _isInitialize = false;
  // bool get isInitialize => _isInitialize;

  // SpeechTextService();

  // final String _currentLocaleId = 'en-US';
  // final _countRetry = 0;

  // Future<bool> initSpeechToText(Function(String) statusListener) async {
  //   _speech = SpeechToText();
  //   final hasSpeech = await _speech.initialize(
  //     onError: (val) => debugPrint('onError: $val'),
  //     debugLogging: true,
  //   );
  //   if (hasSpeech) {
  //     _speech.statusListener = statusListener;
  //     final systemLocale = await _speech.systemLocale();
  //     _currentLocaleId = systemLocale?.localeId ?? 'en-US';
  //     _isInitialize = true;
  //     return true;
  //   }

  //   return false;
  // }

  // Future<void> startSpeak(Function(String) callback) async {
  //   if (_isInitialize) {
  //     debugPrint('[EasyAudio]: start record');
  //     _countRetry = 0;
  //     await _speech.listen(
  //       cancelOnError: false,
  //       localeId: _currentLocaleId,
  //       listenMode: ListenMode.confirmation,
  //       onResult: (value) {
  //         callback(value.alternates.last.recognizedWords);
  //       },
  //     );
  //   } else if (_countRetry < _limitRetry) {
  //     _countRetry++;
  //     await initSpeechToText((s) {
  //       debugPrint('[EasyAudio]: re-init: $s');
  //     });

  //     await startSpeak(callback);
  //   }
  // }

  // Future<void> stopSpeak() async {
  //   if (_speech.isAvailable) {
  //     await _speech.stop();
  //   }
  // }
}
