import 'package:flutter/material.dart';

import 'record_modal_widget.dart';

extension BuildContextAnimatedWaveform on BuildContext {
  Future<T?> startRecord<T>() {
    return showModalBottomSheet(
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
