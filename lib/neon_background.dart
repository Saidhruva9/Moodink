import 'package:flutter/material.dart';

class NeonBackground extends StatefulWidget {
  const NeonBackground({super.key});

  @override
  _NeonBackgroundState createState() => _NeonBackgroundState();
}

class _NeonBackgroundState extends State<NeonBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.deepPurpleAccent,
      end: Colors.cyanAccent,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                _colorAnimation.value ?? Colors.deepPurpleAccent,
                Colors.black,
              ],
              radius: 1.2,
              center: Alignment(0.0, -0.3),
            ),
          ),
        );
      },
    );
  }
}
