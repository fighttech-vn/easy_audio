import 'package:easy_audio/easy_audio.dart';
import 'package:flutter/material.dart';

const kOffsetHide = Offset(0, 2);
const kOffsetShow = Offset(0, 0);

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

extension DurationExt on Duration {
  String get hhmmss {
    return toString().split('.').first.padLeft(8, '0');
  }
}
