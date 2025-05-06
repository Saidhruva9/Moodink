import 'package:flutter/material.dart';
import '../games/bubble_popper_game.dart'; // <-- Import the actual game

class BubblePopperScreen extends StatelessWidget {
  const BubblePopperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bubble Popper Game')),
      body: const BubblePopperGame(), // <-- This calls your real game!
    );
  }
}
