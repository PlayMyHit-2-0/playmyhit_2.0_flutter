import 'package:flutter/material.dart';

class DefaultPostUI extends StatelessWidget {
  const DefaultPostUI({super.key});
  
  @override
  Widget build(BuildContext context) {
    return _defaultWidget();
  }
}

Widget _defaultWidget() => Scaffold(
  appBar: AppBar(title: const Text("Unknown State")),
  body: const Center(
    child: Text("Unknown State In Post")
  )
);