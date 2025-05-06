import 'package:flutter/material.dart';
import 'dart:math';
import 'handwriting_screen.dart';
import 'text_analysis_screen.dart' as text_analysis;
import 'voice_mood_screen.dart';
import 'screens/camera_gallery_emotion_screen.dart';

void main() {
  runApp(const MoodProfilerApp());
}

class MoodProfilerApp extends StatelessWidget {
  const MoodProfilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Profiler',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181A20),
        primaryColor: Colors.tealAccent,
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amberAccent,
        ),
        fontFamily: 'Orbitron',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Orbitron',
            color: Colors.tealAccent,
          ),
          bodyMedium: TextStyle(fontFamily: 'Orbitron', color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.tealAccent,
            letterSpacing: 1.5,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empathy & Self-Awareness')),
      body: Stack(
        children: [
          // Minimalistic, attractive animated background
          const _MinimalisticEmotionBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                // <-- Add scroll for better spacing on small screens
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'How are you feeling today?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Explore your emotions and self-awareness with AI-powered analysis.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontFamily: 'Orbitron',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    _emotionButton(
                      context,
                      icon: Icons.edit,
                      label: 'Handwriting Analysis',
                      color: Colors.tealAccent,
                      screen: const HandwritingScreen(),
                    ),
                    const SizedBox(height: 28), // Increased spacing
                    _emotionButton(
                      context,
                      icon: Icons.mic,
                      label: 'Text / Speech Analysis',
                      color: Colors.amberAccent,
                      screen: text_analysis.TextAnalysisScreen(),
                    ),
                    const SizedBox(height: 28), // Increased spacing
                    // Center the Voice Mood Check button
                    Row(
                      children: [
                        const Spacer(flex: 2),
                        Expanded(
                          flex: 6,
                          child: _emotionButton(
                            context,
                            icon: Icons.graphic_eq,
                            label: 'Voice Mood Check',
                            color: Colors.pinkAccent,
                            screen: VoiceMoodScreen(),
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                    const SizedBox(height: 28), // Increased spacing
                    _emotionButton(
                      context,
                      icon: Icons.camera_alt,
                      label: 'Camera Mood Check',
                      color: Colors.lightBlueAccent,
                      screen: CameraGalleryEmotionScreen(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Themed button for each analysis mode
  Widget _emotionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Widget screen,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28, color: color),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Orbitron',
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.05),
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          shadowColor: color.withOpacity(0.3),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }
}

// --- Minimalistic Animated Background Widget ---
class _MinimalisticEmotionBackground extends StatefulWidget {
  const _MinimalisticEmotionBackground();

  @override
  State<_MinimalisticEmotionBackground> createState() =>
      _MinimalisticEmotionBackgroundState();
}

class _MinimalisticEmotionBackgroundState
    extends State<_MinimalisticEmotionBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_AnimatedCircle> _animatedCircles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 18),
      vsync: this,
    )..repeat();

    // Create animated circles with different speeds, directions, and opacities
    _animatedCircles = [
      _AnimatedCircle(
        color: Colors.tealAccent.withOpacity(0.13),
        baseCenter: const Offset(120, 200),
        baseRadius: 90,
        amplitude: 30,
        speed: 1.0,
        direction: 1,
      ),
      _AnimatedCircle(
        color: Colors.amberAccent.withOpacity(0.11),
        baseCenter: const Offset(320, 500),
        baseRadius: 110,
        amplitude: 40,
        speed: 0.7,
        direction: -1,
      ),
      _AnimatedCircle(
        color: Colors.pinkAccent.withOpacity(0.10),
        baseCenter: const Offset(220, 700),
        baseRadius: 70,
        amplitude: 25,
        speed: 1.3,
        direction: 1,
      ),
      _AnimatedCircle(
        color: Colors.lightBlueAccent.withOpacity(0.09),
        baseCenter: const Offset(60, 600),
        baseRadius: 60,
        amplitude: 20,
        speed: 0.9,
        direction: -1,
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _RealisticEmotionBackgroundPainter(
            _controller.value,
            _animatedCircles,
            size,
          ),
          size: size,
        );
      },
    );
  }
}

class _RealisticEmotionBackgroundPainter extends CustomPainter {
  final double progress;
  final List<_AnimatedCircle> circles;
  final Size screenSize;

  _RealisticEmotionBackgroundPainter(
    this.progress,
    this.circles,
    this.screenSize,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (final circle in circles) {
      final t = progress * 2 * pi * circle.speed * circle.direction;
      final dx =
          circle.baseCenter.dx +
          circle.amplitude *
              sin(0.7 * (1 + circle.direction) * (progress - 0.5));
      final dy = circle.baseCenter.dy + circle.amplitude * cos(t);
      final radius = circle.baseRadius + 8 * sin(t);

      final paint =
          Paint()
            ..color = circle.color
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(
    covariant _RealisticEmotionBackgroundPainter oldDelegate,
  ) => oldDelegate.progress != progress;
}

class _AnimatedCircle {
  final Color color;
  final Offset baseCenter;
  final double baseRadius;
  final double amplitude;
  final double speed;
  final int direction;

  _AnimatedCircle({
    required this.color,
    required this.baseCenter,
    required this.baseRadius,
    required this.amplitude,
    required this.speed,
    required this.direction,
  });
}
