import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isAndroid() {
  return (defaultTargetPlatform == TargetPlatform.android);
}

bool isIos() {
  return (defaultTargetPlatform == TargetPlatform.iOS);
}

bool isMobile() {
  return (defaultTargetPlatform == TargetPlatform.android) || (defaultTargetPlatform == TargetPlatform.iOS);
}

EdgeInsetsGeometry padding() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return const EdgeInsets.fromLTRB(14, 16, 10, 16);
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return const EdgeInsets.fromLTRB(14, 16, 10, 16);
  }

  return const EdgeInsets.fromLTRB(8, 5, 8, 5);
}
