import 'package:flutter/material.dart';

import 'entities/record_data.dart';
import 'record_modal_widget.dart';

extension BuildContextAnimatedWaveform on BuildContext {
  Future<RecordData?> startRecord() {
    return showModalBottomSheet<RecordData?>(
      context: this,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const RecordModalWidget();
      },
    );
  }
}
