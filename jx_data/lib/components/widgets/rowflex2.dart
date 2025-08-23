import 'package:flutter/material.dart';

class JxRowFlex extends StatelessWidget {
  final List<Widget> content;
  final double minWidth;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const JxRowFlex({
    required this.content,
    this.minWidth = 700,
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > minWidth ? _buildRow() : _buildColumn();
  }

  Widget _buildRow() {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.max,
      children: content.map((item) => item).toList(),
    );
  }

  Widget _buildColumn() {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: content,
    );
  }
}
