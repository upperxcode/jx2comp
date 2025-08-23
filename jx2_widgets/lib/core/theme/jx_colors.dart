import 'package:flutter/material.dart';

class JxColors {
  final Color background;
  final Color foreground;
  const JxColors(this.background, this.foreground);

  Map<String, String> toJson() => {
    'background': background.value.toRadixString(16).padLeft(8, '0'),
    'foreground': foreground.value.toRadixString(16).padLeft(8, '0'),
  };

  factory JxColors.fromJson(Map<String, dynamic> json) => JxColors(
    Color(int.parse(json['background'] as String, radix: 16)),
    Color(int.parse(json['foreground'] as String, radix: 16)),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JxColors &&
          runtimeType == other.runtimeType &&
          background == other.background &&
          foreground == other.foreground;

  @override
  int get hashCode => background.hashCode ^ foreground.hashCode;
}
