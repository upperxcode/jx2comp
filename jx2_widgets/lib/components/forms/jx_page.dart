// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';

abstract class Jx2Page extends StatefulWidget {
  final Widget content;
  Jx2Page(this.content) : super(key: UniqueKey());

  @override
  State<Jx2Page> createState() => _PageBaseState();
}

class _PageBaseState extends State<Jx2Page> {
  @override
  void initState() {
    super.initState();
    // Inicialização da página
  }

  @override
  void dispose() {
    super.dispose();
    // Limpeza da página
  }

  @override
  Widget build(BuildContext context) {
    return widget.content;
  }
}
