import 'package:flutter/material.dart';

class PostLoadingUI extends StatelessWidget {
  final String loadingLabel;

  const PostLoadingUI({super.key, required this.loadingLabel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loadingLabel),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}