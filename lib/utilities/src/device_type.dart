
import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet }

DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  var orientation = mediaQueryData.orientation;
  double deviceWidth = 0;

  // Device width regardless of orientation
  orientation == Orientation.portrait
      ? deviceWidth = mediaQueryData.size.width
      : deviceWidth = mediaQueryData.size.height;

  if (deviceWidth < 600) {
    return DeviceType.mobile;
  } else {
    return DeviceType.tablet;
  }
}
