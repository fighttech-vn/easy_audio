import 'dart:async';

import 'package:flutter/material.dart';

import 'easy_audio_controller.dart';
import 'entities/record_data.dart';
import 'record_audio_constants.dart';
import 'services/speech_text_service.dart';
import 'widgets/waveforms_sound/fixed_wareform.dart';

class RecordModalWidget extends StatefulWidget {
  const RecordModalWidget({super.key});

  @override
  State<RecordModalWidget> createState() => _RecordModalWidgetState();
}

class _RecordModalWidgetState extends State<RecordModalWidget> {
  Timer? _timer;
  final _ctlSecond = ValueNotifier(0);
  final _ctlTextSpeech = ValueNotifier<String>('');
  final _audioController = EasyAudioController();
  final _speechTextService = SpeechTextService();

  final _textCtrl = TextEditingController();

  void _speechTextStatusListener(String p1) {}

  void _stopRecord(bool save) {
    _speechTextService.stopSpeak().then((value) {
      if (!save) {
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
    });
  }

  void _recordRun() {
    _audioController.record().then((value) {
      if (_audioController.isRecording) {
        if (_speechTextService.isInitialize) {
          _speechTextService.startSpeak((p0) {
            _textCtrl.text = p0;
          });
        }
      }
    });
  }

  @override
  void initState() {
    _ctlSecond.value = 0;
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _ctlSecond.value = timer.tick;
    });

    _speechTextService
        .initSpeechToText(_speechTextStatusListener)
        .then((value) {
      if (value == false) {
        Navigator.of(context).pop();
      }
    });

    _audioController.initPlayer().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _recordRun();
      });
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
              child: ValueListenableBuilder<String>(
                valueListenable: _ctlTextSpeech,
                builder: (_, texts, __) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      maxLines: 6,
                      controller: _textCtrl,
                    ),
                  );
                },
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
  }
}
