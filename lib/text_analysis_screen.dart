import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secrets.dart';
import 'screens/bubble_popper_screen.dart'; // <-- Make sure this path is correct

class TextAnalysisScreen extends StatefulWidget {
  const TextAnalysisScreen({super.key});

  @override
  _TextAnalysisScreenState createState() => _TextAnalysisScreenState();
}

class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
  final _controller = TextEditingController();
  String? _result;

  Future<void> _analyzeText(String inputText) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$GEMINI_API_KEY',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Analyze the following text and describe the user's emotional tone and mood: \"$inputText\". Keep it simple.",
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['candidates'][0]['content']['parts'][0]['text'];
      setState(() => _result = reply);

      // Show motivational popup, breathing animation, and bubble popper game if mood is sad or depressed
      if (reply.toLowerCase().contains("sad") ||
          reply.toLowerCase().contains("depressed")) {
        // Motivational Quote
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('Keep Pushing'),
                content: Text(
                  'Every day may not be good, but there is good in every day.',
                ),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
        );

        // Breathing Animation
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('Deep Breathing'),
                content: Text('Breathe in... Hold... Breathe out...'),
                actions: [
                  TextButton(
                    child: Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
        );

        // Launch Bubble Popper Game
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => BubblePopperScreen()));
      }
    } else {
      setState(() => _result = "Error analyzing text. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Mood Analysis")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type your thoughts or message...",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _analyzeText(_controller.text),
              child: Text("Analyze Mood"),
            ),
            SizedBox(height: 20),
            if (_result != null) Text(_result!, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class MoodResponseService {
  static void showMotivationalPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Stay Positive!'),
            content: Text(
              'Remember, tough times never last but tough people do.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
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
            title: Text('Take a Deep Breath'),
            content: Text('Breathe in... Breathe out...'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Done'),
              ),
            ],
          ),
    );
  }

  static void launchBubblePopperGame(BuildContext context) {
    // Implement the bubble popper game launch logic here
  }
}
