import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20)
      ),
      child: Container(
        color: const Color.fromRGBO(217, 217, 217, 1),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Row(
            children: [
              Icon(Icons.home, color: Colors.redAccent),
              Icon(Icons.music_note, color: Colors.redAccent),
              Icon(Icons.videocam, color: Colors.redAccent),
              Icon(Icons.image, color: Colors.redAccent),
              Spacer(flex: 1),
              Badge(
                child: Icon(Icons.notifications, color: Colors.redAccent)
              )
            ],
          )
        )
      )
    );
  }
}