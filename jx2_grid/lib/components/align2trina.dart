import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

TrinaColumnTextAlign align2Trina(TextAlign align) {
  switch (align) {
    case TextAlign.center:
      return TrinaColumnTextAlign.center;
    case TextAlign.left:
      return TrinaColumnTextAlign.left;
    case TextAlign.right:
      return TrinaColumnTextAlign.right;
    case TextAlign.end:
      return TrinaColumnTextAlign.end;
    default:
      return TrinaColumnTextAlign.start;
  }
}
