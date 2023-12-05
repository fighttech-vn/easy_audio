import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/speech_to_text_usecase.dart';
import '../../../record_audio_constants.dart';
import '../state_ui/speech_text_state_ui.dart';

part 'speech_text_event.dart';
part 'speech_text_state.dart';

class SpeechTextBloc extends Bloc<SpeechTextEvent, SpeechTextState> {
  final SpeechToTextUsecase _speechToTextUsecase;

  SpeechTextBloc(this._speechToTextUsecase)
      : super(const SpeechTextInitial(SpeechTextStateUI())) {
    on<InitSpeechToTextEvent>(_onMapInitSpeechToTextEvent);
    on<StartRecordEvent>(_onMapStartRecordEvent);
    on<StopRecordEvent>(_onMapStopRecordEvent);

    add(InitSpeechToTextEvent(retryCount: 0));
  }

  FutureOr<void> _onMapInitSpeechToTextEvent(
      InitSpeechToTextEvent event, Emitter<SpeechTextState> emit) async {
    try {
      emit(InitialingService(state.stateUI));
      final currentLocaleId = await _speechToTextUsecase.initSpeechToText();
      if (currentLocaleId?.isNotEmpty ?? false) {
        emit(InitSucceeded(state.stateUI.copyWith(
          currentLocaleId: currentLocaleId,
          stateInit: StateInitSpeechText.succeeded,
        )));
      } else {
        emit(InitFailed(
          state.stateUI.copyWith(
            stateInit: StateInitSpeechText.failed,
          ),
        ));
      }
    } catch (e) {
      emit(InitFailed(state.stateUI.copyWith(
        stateInit: StateInitSpeechText.failed,
      )));
    }
  }

  FutureOr<void> _onMapStartRecordEvent(
      StartRecordEvent event, Emitter<SpeechTextState> emit) async {
    try {
      if (state.stateUI.isInitSuccess) {
        _speechToTextUsecase.startSpeak(
          event.callbackToText,
          state.stateUI.currentLocaleId,
        );

        emit(Recording(state.stateUI));
      } else if (state.stateUI.isCloseFeature == false) {
        add(InitSpeechToTextEvent(
            retryCount: state.stateUI.retryInitCount + 1));
      } else {
        emit(InitFailed(state.stateUI));
      }
    } catch (e) {
      emit(RecordError(state.stateUI, e.toString(), e));
    }
  }

  FutureOr<void> _onMapStopRecordEvent(
      StopRecordEvent event, Emitter<SpeechTextState> emit) async {
    try {
      if (state.stateUI.isInitSuccess) {
        emit(StopingRecord(state.stateUI));

        await _speechToTextUsecase.stopSpeak();

        emit(StoppedRecord(state.stateUI, event.isSave));
      }
    } catch (e) {
      emit(RecordError(state.stateUI, e.toString(), e));
    }
  }
}
