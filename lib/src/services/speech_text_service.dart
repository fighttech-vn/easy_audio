import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTextService {
  late SpeechToText _speech;
  bool _isInitialize = false;
  bool get isInitialize => _isInitialize;

  SpeechTextService();

  String _currentLocaleId = 'en-US';

  Future<bool> initSpeechToText(Function(String) statusListener) async {
    _speech = SpeechToText();
    final hasSpeech = await _speech.initialize(
      onError: (val) => debugPrint('onError: $val'),
      debugLogging: true,
    );
    if (hasSpeech) {
      _speech.statusListener = statusListener;
      final systemLocale = await _speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? 'en-US';
      _isInitialize = true;
      return true;
    }

    return false;
  }

  void startSpeak(Function(String) callback) {
    if (_isInitialize) {
      _speech.listen(
        cancelOnError: false,
        localeId: _currentLocaleId,
        listenMode: ListenMode.confirmation,
        onResult: (value) {
          callback(value.alternates.last.recognizedWords);
        },
      );
    }
  }

  Future<void> stopSpeak() async {
    if (_speech.isAvailable) {
      await _speech.stop();
    }
  }
}
