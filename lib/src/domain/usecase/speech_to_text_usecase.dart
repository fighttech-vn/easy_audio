import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextUsecase {
  final String? local;

  SpeechToTextUsecase({
    this.local,
  });

  ///
  /// service handle stt
  ///
  final SpeechToText _speech = SpeechToText();

  Future<String?> initSpeechToText({Function(String)? statusListener}) async {
    final hasSpeech = await _speech.initialize(
      onError: (val) => debugPrint('onError: $val'),
      debugLogging: true,
    );

    if (hasSpeech) {
      if (statusListener != null) {
        _speech.statusListener = statusListener;
      }

      final systemLocale = await _speech.systemLocale();
      return local ?? systemLocale?.localeId ?? 'en-US';
    }

    return local;
  }

  void startSpeak(
    Function(String) callback,
    String currentLocaleId,
  ) {
    debugPrint('[EasyAudio]: start record with locale: $currentLocaleId');
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
    if (_speech.isAvailable == true) {
      await _speech.stop();
    }
  }
}
