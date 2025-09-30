import 'package:flutter/material.dart';

import 'package:jx_data/components/widgets/form_button.dart';

class JxForm extends StatelessWidget {
  final List<Widget> content;
  final GlobalKey<FormState> formkey;
  final Color? color;
  final double? bordeRadius;
  final FormButton? buttons;
  const JxForm({
    required this.formkey,
    required this.content,
    this.color,
    this.bordeRadius,
    super.key,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return FormAndroid(formkey: formkey, buttons: buttons, content: content);
  }
}

class FormAndroid extends StatelessWidget {
  final List<Widget> content;
  final GlobalKey<FormState> formkey;
  final FormButton? buttons;

  final Color? color;
  final double? bordeRadius;
  const FormAndroid({
    required this.formkey,
    required this.content,
    this.color,
    this.bordeRadius,
    super.key,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(bordeRadius ?? 0),
      //set border radius more than 50% of height and width to make circle
    );
    return Form(
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Card(
              color: Colors.amber,
              elevation: 5,
              shape: shape,
              shadowColor: Colors.black54,

              clipBehavior: Clip.antiAlias,
              child: ListView(
                children: [
                  ...content,
                  // Expanded(child: Container()),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 80.0,
            child: Card(child: buttons, elevation: 5, shape: shape),
          ),
        ],
      ),
    );
  }
}

class FormDesktop extends StatelessWidget {
  final List<Widget> content;
  final GlobalKey<FormState> formkey;
  final Color? color;
  final double? bordeRadius;
  const FormDesktop({
    required this.formkey,
    required this.content,
    this.color,
    this.bordeRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(bordeRadius ?? 0),
          //set border radius more than 50% of height and width to make circle
        ),
        shadowColor: Colors.black54,
        color: color ?? Colors.white54,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: content,
        ),
      ),
    );
  }
}
