import 'package:flutter/material.dart';

import 'effects/indicator_effect.dart';
import 'effects/worm_effect.dart';
import 'painters/indicator_painter.dart';

int _indicatorCount;
int _indicatorIndex;

class SmoothPageIndicator extends AnimatedWidget {
  // a PageView controller to listen for page offset updates
  final PageController controller;

  final IndicatorController indicatorController;

  /// Holds effect configuration to be used in the [IndicatorPainter]
  final IndicatorEffect effect;

  /// The number of children in [PageView]
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page offset will be reversed
  final TextDirection textDirection;

  SmoothPageIndicator({
    this.controller,
    this.indicatorController,
    @required this.count,
    this.textDirection,
    this.effect = const WormEffect(),
    Key key,
  })  : assert(controller != null || indicatorController != null),
        assert(effect != null),
        assert(count != null),
        super(listenable: controller, key: key) {
    _indicatorCount = count;
    if (indicatorController != null) {
      _indicatorIndex = indicatorController.initialPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    // if textDirection is not provided use the nearest directionality up the widgets tree;
    final isRTL =
        (textDirection ?? Directionality.of(context)) == TextDirection.rtl;
    return CustomPaint(
      // different effects have different sizes
      // so we calculate size based on the provided effect
      size: effect.calculateSize(count),
      // rebuild the painter with the new offset every time it updates
      painter: effect.buildPainter(
        count,
        controller != null
            ? _currentPage.toDouble()
            : _indicatorIndex.toDouble(),
        isRTL,
      ),
    );
  }

  double get _currentPage {
    try {
      return controller.page ?? controller.initialPage.toDouble();
    } catch (Exception) {
      return controller.initialPage.toDouble();
    }
  }
}

class IndicatorController {
  final int initialPage;

  IndicatorController({this.initialPage = 0}) : assert(initialPage != null);

  void next() {
    if (_indicatorIndex < _indicatorCount) {
      _indicatorIndex++;
    } else {
      _indicatorIndex = 0;
    }
  }
}
