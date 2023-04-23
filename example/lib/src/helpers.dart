extension DurationExt on Duration {
  String get timeHHmm => timeFormat('HH:mm');
  String get timemmss => timeFormat('mm:ss');

  String timeFormat(String format) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final dataTime = {};
    dataTime['H'] = inHours.toString();
    dataTime['HH'] = twoDigits(inHours);
    dataTime['mm'] = twoDigits(inMinutes.remainder(60));
    dataTime['m'] = inMinutes.remainder(60);
    dataTime['ss'] = twoDigits(inSeconds.remainder(60));
    dataTime['s'] = inSeconds.remainder(60);

    final formatTime = format.split(':');

    return formatTime.map((e) => dataTime[e] ?? '').toList().join(':');
  }

  String get hhmmss {
    return toString().split('.').first.padLeft(8, '0');
  }
}
