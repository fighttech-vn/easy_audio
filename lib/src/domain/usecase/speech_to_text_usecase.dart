import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextUsecase {
  late SpeechToText _speech;

  Future<String?> initSpeechToText({Function(String)? statusListener}) async {
    _speech = SpeechToText();
    final hasSpeech = await _speech.initialize(
      onError: (val) => debugPrint('onError: $val'),
      debugLogging: true,
    );
    if (hasSpeech) {
      if (statusListener != null) {
        _speech.statusListener = statusListener;
      }

      final systemLocale = await _speech.systemLocale();
      return systemLocale?.localeId ?? 'en-US';
    }

    return null;
  }

  void startSpeak(
    Function(String) callback,
    String currentLocaleId,
  ) {
    debugPrint('[EasyAudio]: start record');
    _speech.listen(
      cancelOnError: false,
      localeId: currentLocaleId,
      listenMode: ListenMode.confirmation,
      onResult: (value) {
        callback(value.alternates.last.recognizedWords);
      },
    );
  }

  Future<void> stopSpeak() async {
    if (_speech.isAvailable) {
      await _speech.stop();
    }
  }
}
