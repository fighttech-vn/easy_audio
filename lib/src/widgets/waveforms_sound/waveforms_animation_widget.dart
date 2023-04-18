import 'package:flutter/material.dart';

import 'wareforms_sourd_widget.dart';
import 'waveforms_sound_constants.dart';

const _kHeightWidget = 80.0;

class WaveFormsAnimationWidget extends StatefulWidget {
  const WaveFormsAnimationWidget({
    super.key,
    this.colorBackground = Colors.white,
  });

  final Color colorBackground;

  @override
  State<WaveFormsAnimationWidget> createState() =>
      _WaveFormsAnimationWidgetState();
}

class _WaveFormsAnimationWidgetState extends State<WaveFormsAnimationWidget>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  void _listenerAnimation() {
    if (animation.value == 1) {
      controller.reverse();
    } else if (animation.value == 0) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.stop();
    animation.removeListener(_listenerAnimation);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut))
      ..addListener(_listenerAnimation);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kHeightWidget,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          return WaveformsSoundWidget(
            widthItem: 5,
            spacing: 5,
            percentItem: WaveformsSoundConstant.defaultPercentItem,
            sizeBG: animation.value,
            colorFill: Theme.of(context).colorScheme.secondary,
            colorDefault: Colors.grey,
            colorBackground: widget.colorBackground,
          );
        },
      ),
    );
  }
}
