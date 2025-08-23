import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/textfields/suffix_icon.dart';

class DoubleIconsRow extends StatelessWidget {
  final Function() onTap1;
  final Function() onTap2;
  final Widget icon1;
  final Widget? icon2;
  const DoubleIconsRow({
    super.key,
    required this.onTap1,
    required this.onTap2,
    required this.icon1,
    required this.icon2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          JxSuffixIcon(onTap: onTap1, child: icon1),
          const SizedBox(width: 2),
          if (icon2 != null) JxSuffixIcon(onTap: onTap2, child: icon2!),
        ],
      ),
    );
  }
}
