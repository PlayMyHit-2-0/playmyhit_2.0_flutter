import 'package:flutter/material.dart';

class UnauthorizedView extends StatelessWidget {
  const UnauthorizedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("You are not authorized to view this content.")
    );
  }  
}