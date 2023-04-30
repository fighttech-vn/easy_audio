import 'package:easy_audio/easy_audio.dart';
import 'package:example/src/helpers.dart';
import 'package:flutter/material.dart';

const _kOffsetHide = Offset(0, 2);
const _kOffsetShow = Offset(0, 0);

class EasyAudioExampleScreen extends StatefulWidget {
  const EasyAudioExampleScreen({super.key});

  @override
  State<EasyAudioExampleScreen> createState() => _EasyAudioExampleScreenState();
}

class _EasyAudioExampleScreenState extends State<EasyAudioExampleScreen> {
  final EasyAudioController _audioController = EasyAudioController();
  var _offset = _kOffsetHide;
  var _urlPlay = '';

  void _startRecord() {
    context.startRecord().then((value) {
      if (value != null) {
        kMockDataRecord.add(value);
        _playAudio(value.url);
      }
    });
  }

  void _init() {
    _audioController.initPlayer(false);
    _audioController.addListener(() {
      if (_offset == _kOffsetHide && _audioController.isOpenPlayer) {
        setState(() {
          _offset = _kOffsetShow;
        });
      }
      if (_audioController.isPlaying == false) {
        setState(() {
          _offset = _kOffsetHide;
        });
      }
    });
  }

  void _playAudio(String url) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    setState(() {
      _urlPlay = url;
      _audioController.play(_urlPlay);
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _audioController.forceDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizeBottom = 110.0;
    final isShowBottom = MediaQuery.of(context).viewInsets.bottom == 0 &&
        _offset == _kOffsetShow;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Audio Example Screen'),
      ),
      extendBody: true,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: isShowBottom ? sizeBottom : 0),
              child: Column(
                children: kMockDataRecord
                    .map(
                      (item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        dense: true,
                        onTap: () {
                          final isPlaying = _urlPlay == item.title;
                          if (isPlaying) {
                            return;
                          } else {
                            if (_offset == _kOffsetHide) {
                              _offset = _kOffsetShow;
                            }

                            _playAudio(item.url);
                          }
                        },
                        title: Text(
                          item.title ?? 'record',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: Text(item.totalTime.timemmss),
                      ),
                    )
                    .toList(),
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
              Positioned(
                bottom: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: MediaQuery.of(context).viewInsets.bottom != 0
                      ? _kOffsetHide
                      : _offset,
                  child: EasyAudioPlayer(
                    controller: _audioController,
                    formatTimeSlider: (duration) => duration.timemmss,
                    builderSlider: (duration, posision, isLoadDone) {
                      var timeValue = 0.0;
                      if (isLoadDone && posision != null && duration != null) {
                        timeValue =
                            posision.inMilliseconds / duration.inMilliseconds;
                      }

                      return Slider(
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Theme.of(context).colorScheme.secondary,
                        value: timeValue,
                        onChanged: (value) {},
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: MediaQuery.of(context).viewInsets.bottom != 0
                      ? _kOffsetHide
                      : (_offset == _kOffsetHide ? _kOffsetShow : _kOffsetHide),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _startRecord,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

final kMockDataRecord = [
  RecordData(
    title: 'Recording-003',
    createdAt: DateTime(2022, 12, 5, 09, 25),
    id: '006',
    totalTime: const Duration(seconds: 91),
    url:
        'https://flutter-sound.canardoux.xyz/web_example/assets/extract/05.mp3',
  ),
  RecordData(
    title: 'Recording-002',
    createdAt: DateTime(2022, 12, 4, 09, 25),
    id: '005',
    totalTime: const Duration(seconds: 62),
    url:
        'https://flutter-sound.canardoux.xyz/web_example/assets/extract/01.aac',
  ),
  RecordData(
    title: 'Recording-001',
    createdAt: DateTime(2022, 11, 29, 09, 25),
    id: '004',
    totalTime: const Duration(seconds: 91),
    url:
        'https://flutter-sound.canardoux.xyz/web_example/assets/extract/05.mp3',
  ),
];
