import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/entities/record_data.dart';
import 'domain/usecase/speech_to_text_usecase.dart';
import 'presentation/record_modal/bloc/speech_text_bloc.dart';
import 'presentation/record_modal/record_modal_widget.dart';

extension BuildContextAnimatedWaveform on BuildContext {
  Future<RecordData?> startRecord({
    Future<bool?> Function()? onExits,
    String? transcript,
    String locale = 'en-US',
  }) {
    return showModalBottomSheet<RecordData?>(
      context: this,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.black26,
      barrierColor: Colors.transparent,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(this).size.height),
      builder: (BuildContext context) {
        return BlocProvider<SpeechTextBloc>(
          create: (context) =>
              SpeechTextBloc(SpeechToTextUsecase(local: locale)),
          child: RecordModalWidget(
            onExits: onExits,
            title: transcript,
          ),
        );
      },
    );
  }
}
