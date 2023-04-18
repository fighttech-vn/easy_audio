import 'package:flutter/material.dart';

class WaveformsSoundWidget extends StatelessWidget {
  final double widthItem;
  final double spacing;
  final List<int> percentItem;
  final double sizeBG;
  final Color colorFill;
  final Color colorDefault;
  final Color colorBackground;

  const WaveformsSoundWidget({
    super.key,
    required this.percentItem,
    required this.widthItem,
    this.spacing = 5,
    required this.sizeBG,
    required this.colorFill,
    required this.colorDefault,
    this.colorBackground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final fullSizeItem = percentItem.length * (widthItem + spacing);
    final widthBG = sizeBG * fullSizeItem;
    return LayoutBuilder(builder: (_, constrain) {
      return SizedBox(
        width: fullSizeItem,
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: widthBG,
                    height: constrain.maxHeight,
                    color: colorFill,
                  ),
                  Container(
                    width: fullSizeItem - widthBG,
                    height: constrain.maxHeight,
                    color: colorDefault,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constrain.maxHeight + 10,
              width: MediaQuery.of(context).size.width,
              child: ColorFiltered(
                colorFilter:
                    ColorFilter.mode(colorBackground, BlendMode.srcOut),
                child: Container(
                  color: Colors.transparent,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      children: List.generate(
                        percentItem.isEmpty ? 0 : (percentItem.length * 2 - 1),
                        (index) {
                          if (index % 2 == 0) {
                            final height = (percentItem[index ~/ 2] / 100) *
                                constrain.maxHeight;
                            return Container(
                              height: height,
                              width: widthItem,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(widthItem / 2),
                              ),
                            );
                          }

                          return SizedBox(width: spacing);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
