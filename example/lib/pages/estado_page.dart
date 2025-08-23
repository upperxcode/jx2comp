import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/button/core/button_types.dart';
import 'package:jx2_widgets/components/button/floating_button.dart';
import 'package:jx2_widgets/components/forms/jx_page.dart';
import 'package:jx2_widgets/core/appbar.dart';

class EstadoPage extends Jx2Page {
  EstadoPage() : super(Text('Hello World'));

  @override
  State<EstadoPage> createState() => _EstadoPageState();
}

class _EstadoPageState extends State<EstadoPage> {
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
