import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return _fromWidth(width);
  }

  static DeviceType fromConstraints(BoxConstraints constraints) {
    return _fromWidth(constraints.maxWidth);
  }

  static DeviceType _fromWidth(double width) {
    if (width < mobileBreakpoint) return DeviceType.mobile;
    if (width < tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final device = getDeviceType(context);
    switch (device) {
      case DeviceType.desktop:
        return desktop;
      case DeviceType.tablet:
        return tablet ?? desktop;
      case DeviceType.mobile:
        return mobile;
    }
  }

  static T valueFromConstraints<T>({
    required BoxConstraints constraints,
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final device = fromConstraints(constraints);
    switch (device) {
      case DeviceType.desktop:
        return desktop;
      case DeviceType.tablet:
        return tablet ?? desktop;
      case DeviceType.mobile:
        return mobile;
    }
  }
}
