import 'package:record/record.dart';

/// dBFS amplitude
class Amp {
  Amp({required this.current, required this.max});

  /// Current max amplitude
  final double current;

  /// Top max amplitude
  final double max;
}

extension AmplitudeExt on Amplitude {
  Amp toAmp() => Amp(current: current, max: max);
}
