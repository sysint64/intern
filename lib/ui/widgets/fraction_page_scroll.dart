part of '../widgets.dart';
// Original solution: https://gist.github.com/rolurq/5db4c0cb7db66cf8f5a59396faeec7fa
// Stack overflow: https://stackoverflow.com/questions/56871898/align-a-flutter-pageview-to-the-screen-left

class FractionPageScrollPhysics extends ScrollPhysics {
  final double? itemDimension;
  final EdgeInsets padding;

  const FractionPageScrollPhysics({
    this.itemDimension,
    this.padding = EdgeInsets.zero,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  FractionPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FractionPageScrollPhysics(
      itemDimension: itemDimension,
      padding: padding,
      parent: buildParent(ancestor),
    );
  }

  double _getPage(ScrollPosition position, double portion) {
    return (position.pixels + portion) / itemDimension!;
  }

  double _getPixels(double page, double portion) {
    return (page * itemDimension!) - portion;
  }

  double _getTargetPixels(
    ScrollPosition position,
    Tolerance tolerance,
    double velocity,
    double portion,
  ) {
    var page = _getPage(position, portion);

    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(page.roundToDouble(), portion);
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final tolerance = this.tolerance;
    final portion = (position.extentInside - padding.horizontal - itemDimension!) / 2;
    final target = _getTargetPixels(position as ScrollPosition, tolerance, velocity, portion);

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    } else {
      return null;
    }
  }

  @override
  bool get allowImplicitScrolling => false;
}
