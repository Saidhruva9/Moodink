import 'package:flutter/material.dart';
import 'dart:math';

class BubblePopperGame extends StatefulWidget {
  const BubblePopperGame({super.key});

  @override
  State<BubblePopperGame> createState() => _BubblePopperGameState();
}

class _BubblePopperGameState extends State<BubblePopperGame> {
  final List<Offset> bubbles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateBubbles();
  }

  void generateBubbles() {
    for (int i = 0; i < 20; i++) {
      bubbles.add(Offset(random.nextDouble() * 300, random.nextDouble() * 500));
    }
  }

  void popBubble(int index) {
    setState(() {
      bubbles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bubble Popper Game')),
      body: Stack(
        children:
            bubbles.asMap().entries.map((entry) {
              int index = entry.key;
              Offset position = entry.value;
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: GestureDetector(
                  onTap: () => popBubble(index),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
