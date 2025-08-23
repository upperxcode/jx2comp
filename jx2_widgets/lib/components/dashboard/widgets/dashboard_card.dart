import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final IconData icon;
  final Color iconColor;
  final double? width;
  final bool showValue;

  const DashboardCard({
    super.key,
    required this.title,
    this.subtitle,
    this.value,
    required this.icon,
    required this.iconColor,
    this.width,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isNarrow = constraints.maxWidth < 200;

        return Container(
            width: width ?? constraints.maxWidth, // Default width if not provided
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        color: iconColor,
                        size: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 5),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (showValue && value != null) ...[
                        SizedBox(height: 10),
                        Text(
                          value!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (subtitle != null) ...[
                              SizedBox(height: 5),
                              Text(
                                subtitle!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                            if (showValue && value != null) ...[
                              SizedBox(height: 10),
                              Text(
                                value!,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        icon,
                        color: iconColor,
                        size: 60,
                      ),
                    ],
                  ),
          
        );
      },
    );
  }
}