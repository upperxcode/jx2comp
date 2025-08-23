import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/button/jx2button.dart';
import 'package:jx2_widgets/components/forms/jx_page.dart';
import 'package:jx2_widgets/core/appbar.dart';

class Home extends Jx2Page {
  Home() : super(Text('Hello World'));

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appbar = Jx2AppBar(
      title: 'Hello World',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            incrementCounter();
          },
        ),
      ],
      backgroundColor: Colors.blue,
    );
    return Scaffold(
      appBar: appbar,
      body: center(counter),
      floatingActionButton: Jx2FloatingButton(
        onPressed: incrementCounter,
        icon: Icons.add,
        type: Jx2ButtonType.success,
      ),
    );
  }
}

Widget center(int value) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('You have pushed the button this many times:'),
        Text('$value'),
      ],
    ),
  );
}
