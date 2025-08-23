import 'dart:async';
import 'package:flutter/material.dart';

enum SMType { error, warning, information }

Color smColor(SMType type) {
  switch (type) {
    case SMType.error:
      return Colors.red;
    case SMType.warning:
      return Colors.orange;
    case SMType.information:
      return Colors.green;
  }
}

Icon smIcon(SMType type) {
  const color = Colors.white;
  switch (type) {
    case SMType.error:
      return const Icon(Icons.error, color: color);
    case SMType.warning:
      return const Icon(Icons.warning, color: color);
    case SMType.information:
      return const Icon(Icons.info, color: color);
  }
}

class SnackMessage extends StatelessWidget {
  final BuildContext context;
  final String message;
  final Function()? afterExecutMethod;
  final int second;
  final SMType type;

  const SnackMessage({
    super.key,
    required this.context,
    required this.message,
    required this.afterExecutMethod,
    this.second = 4,
    this.type = SMType.information,
  });

  @override
  Widget build(BuildContext context) {
    //bool isExecute = true;
    return Container(child: null);
  }
}

void snackMessage(
  BuildContext context,
  String contentText,
  void Function() afterExecuteMethod, [
  int second = 4,
  SMType type = SMType.information,
]) {
  bool isExecute = true;
  final snackbar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 22.0),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: second * 1000.toDouble()),
            duration: Duration(seconds: second),
            builder: (context, double value, child) {
              return Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      value: value / (second * 500),
                      color: Colors.grey[850],
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Center(
                    child: Text(
                      (second - (value / 1000)).toInt().toString(),
                      textScaleFactor: 0.85,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(child: Text(contentText)),
        InkWell(
          splashColor: Colors.white,
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            isExecute = !isExecute;
            return;
          },
          child: smIcon(type),
        ),
      ],
    ),
    backgroundColor: smColor(type),
    duration: Duration(seconds: second),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(6.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackbar);

  Timer(Duration(seconds: second), () {
    if (isExecute) afterExecuteMethod();
  });
}
