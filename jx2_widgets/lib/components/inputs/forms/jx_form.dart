import 'package:flutter/material.dart';

class JxForm extends StatelessWidget {
  final List<Widget> content;
  final GlobalKey<FormState> formkey;
  final Color? color;
  final double? bordeRadius;
  const JxForm({
    required this.formkey,
    required this.content,
    this.color,
    this.bordeRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormAndroid(formkey: formkey, content: content);
  }
}

class FormAndroid extends StatelessWidget {
  final List<Widget> content;
  final GlobalKey<FormState> formkey;

  final Color? color;
  final double? bordeRadius;
  const FormAndroid({
    required this.formkey,
    required this.content,
    this.color,
    this.bordeRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 60,
        child: Form(
          key: formkey,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(bordeRadius ?? 0),
              //set border radius more than 50% of height and width to make circle
            ),
            shadowColor: Colors.black54,
            color: color ?? Colors.white54,
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: content,
            ),
          ),
        ),
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
