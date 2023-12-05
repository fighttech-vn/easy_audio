import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/entities/record_data.dart';
import 'domain/usecase/speech_to_text_usecase.dart';
import 'presentation/record_modal/bloc/speech_text_bloc.dart';
import 'presentation/record_modal/record_modal_widget.dart';

extension BuildContextAnimatedWaveform on BuildContext {
  Future<RecordData?> startRecord({String? transcript}) {
    return showModalBottomSheet<RecordData?>(
      context: this,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlocProvider<SpeechTextBloc>(
          create: (context) => SpeechTextBloc(SpeechToTextUsecase()),
          child: RecordModalWidget(
            title: transcript,
          ),
        );
      },
    );
  }
}
