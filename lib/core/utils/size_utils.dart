import 'package:flutter/material.dart';

const num designWidth = 360;
const num designHeight = 800;
// ignore: constant_identifier_names
const num statusBar = 0;

typedef ResponsiveBuild = Widget Function(
  BuildContext context,
  Orientation orientation,
  DeviceType deviceType,
);

class Sizer extends StatelessWidget {
  const Sizer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    SizeUtils.setScreenSize(MediaQuery.of(context).size, MediaQuery.of(context).orientation);

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

class SizeUtils {
  static late Orientation orientation;
  static late DeviceType deviceType;
  static late double height;
  static late double width;

static void setScreenSize(
  Size screenSize,
  Orientation currentOrientation,
) {
  orientation = currentOrientation;

  if (orientation == Orientation.portrait) {
    width = screenSize.width.isNonZero(defaultValue: designWidth);
    height = screenSize.height.isNonZero(defaultValue: designHeight);
  } else {
    width = screenSize.height.isNonZero(defaultValue: designHeight);
    height = screenSize.width.isNonZero(defaultValue: designWidth);
  }

  deviceType = DeviceType.mobile;
}
}

extension ResponsiveExtension on num {
  double get _width => SizeUtils.width;
  double get _height => SizeUtils.height;

  double get h => ((this * _width) / designWidth);
  double get v => (this * _height) / (designHeight - statusBar);

  double get adaptSize {
    var height = v;
    var width = h;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  double get fSize => adaptSize;
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType { mobile, tablet, desktop }
