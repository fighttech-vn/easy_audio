import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/record_data.dart';
import '../../record_audio_constants.dart';
import '../shared/services/easy_audio_controller.dart';
import '../shared/widgets/waveforms_sound/fixed_wareform.dart';
import 'bloc/speech_text_bloc.dart';

class RecordModalWidget extends StatefulWidget {
  const RecordModalWidget({super.key});

  @override
  State<RecordModalWidget> createState() => _RecordModalWidgetState();
}

class _RecordModalWidgetState extends State<RecordModalWidget> {
  Timer? _timer;
  final _ctlSecond = ValueNotifier(0);
  final _audioController = EasyAudioController();

  final _textCtrl = TextEditingController();

  void _stopRecord(bool save) {
    context.read<SpeechTextBloc>().add(StopRecordEvent(isSave: save));
  }

  void _recordRun() {
    _audioController.initPlayer().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<SpeechTextBloc>().add(
          StartRecordEvent(callbackToText: (text) {
            _textCtrl.text = text;
          }),
        );
      });
    });
  }

  void _onListenerSpeechTextBloc(BuildContext context, SpeechTextState state) {
    if (state is InitFailed && state.stateUI.isCloseFeature) {
      Navigator.of(context).pop();
    } else if (state is InitSucceeded) {
      _recordRun();
    } else if (state is StoppedRecord) {
      if (state.isSave == false) {
        return Navigator.of(context).pop();
      }

      _audioController.stopRecorder()?.then((value) {
        RecordData? record;
        if (value != null) {
          record = RecordData(
            createdAt: DateTime.now(),
            url: value,
            totalTime: Duration(milliseconds: _audioController.timeRecord),
            content: _textCtrl.text,
          );
        }

        Navigator.of(context).pop(record);
      });
    }
  }

  @override
  void initState() {
    _ctlSecond.value = 0;
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _ctlSecond.value = timer.tick;
    });

    super.initState();
  }

  @override
  void dispose() {
    _audioController.forceDispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpeechTextBloc, SpeechTextState>(
      listener: _onListenerSpeechTextBloc,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0, -1),
                spreadRadius: 1.0,
              ),
            ],
          ),
          height: 150 + 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Content record:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      maxLines: 6,
                      controller: _textCtrl,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _stopRecord(false),
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ValueListenableBuilder<int>(
                      valueListenable: _ctlSecond,
                      builder: (_, sec, __) {
                        return Text(Duration(seconds: sec).formatTimeAudio);
                      },
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _stopRecord(true),
                    icon: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
              const Expanded(
                child: Center(
                  child: SizedBox(
                    height: 150,
                    child: AnimatedWaveform(divide: 3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
