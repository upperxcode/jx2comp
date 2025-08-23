import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/styles/form_text_style.dart';

import '../../styles/field_title.dart';

class JxTextForm extends StatelessWidget {
  final String content;
  final String title;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color fillColor;

  const JxTextForm(
    this.content, {
    super.key,
    required this.title,
    this.padding = const EdgeInsets.all(10.0), // Default padding for content
    this.titleStyle,
    this.contentStyle,
    this.borderColor = Colors.grey, // Default border color
    this.borderWidth = 1.0, // Default border width
    this.borderRadius = 4.0, // Default border radius
    this.fillColor = Colors.transparent, // Default background color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align title to the start
        children: [
          // Title
          if (title.isNotEmpty) // Only show title if it's not empty
            Row(
              // Space between title and content
              children: [FieldTitle(title), const SizedBox(width: 5)],
            ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity, // Take full width
            padding: padding,
            decoration: BoxDecoration(
              color: fillColor,
              border: jxBoxtBorderStyle(),
              borderRadius: BorderRadius.circular(radiuTextField),
            ),
            child: Text(
              content,
              style: jxFormTextStyle(),
              softWrap: true, // Allow text to wrap
              overflow: TextOverflow.clip, // Clip if still overflows
            ),
          ),
        ],
      ),
    );
  }
}
