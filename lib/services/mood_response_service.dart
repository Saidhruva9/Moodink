import 'package:flutter/material.dart';
import '../screens/bubble_popper_screen.dart';

class MoodResponseService {
  static final List<String> motivationalQuotes = [
    "Keep pushing forward!",
    "Believe in yourself!",
    "Every day is a new beginning.",
    "You are stronger than you think.",
    "Difficult roads often lead to beautiful destinations.",
  ];

  static String getRandomMotivationalQuote() {
    motivationalQuotes.shuffle();
    return motivationalQuotes.first;
  }

  static void showMotivationalPopup(BuildContext context) {
    final quote = getRandomMotivationalQuote();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Motivation"),
            content: Text(quote),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  static void showBreathingAnimation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Breathe"),
            content: SizedBox(
              height: 150,
              child: Center(
                child: TweenAnimationBuilder(
                  tween: Tween(begin: 50.0, end: 150.0),
                  duration: Duration(seconds: 3),
                  builder: (_, double size, __) {
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    );
                  },
                  onEnd: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
    );
  }

  static void launchBubblePopperGame(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => BubblePopperScreen()));
  }
}
