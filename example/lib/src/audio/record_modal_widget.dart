import 'dart:async';

import 'package:easy_audio/easy_audio.dart';
import 'package:example/src/helpers.dart';
import 'package:flutter/material.dart';

import 'widgets/fixed_wareform.dart';

class RecordModalWidget extends StatefulWidget {
  const RecordModalWidget({super.key});

  @override
  State<RecordModalWidget> createState() => _RecordModalWidgetState();
}

class _RecordModalWidgetState extends State<RecordModalWidget> {
  final _ctlSecond = ValueNotifier(0);

  final _audioController = EasyAudioController();

  Timer? _timer;

  void _stopRecord(bool save) {
    if (!save) {
      return Navigator.of(context).pop();
    }
    _audioController
        .stopRecorder()
        ?.then((value) => Navigator.of(context).pop(value));

  }

  @override
  void initState() {
    _audioController.record();

    _ctlSecond.value = 0;
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _ctlSecond.value = timer.tick;
    });

    super.initState();
  }

  @override
  void dispose() {
    _stopRecord(true);
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
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                    return Text(Duration(seconds: sec).hhmmss);
                  },
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(true),
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
