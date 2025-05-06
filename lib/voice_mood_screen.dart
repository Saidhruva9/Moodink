import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'screens/bubble_popper_screen.dart'; // Update path if needed

class VoiceMoodScreen extends StatefulWidget {
  const VoiceMoodScreen({super.key});

  @override
  State<VoiceMoodScreen> createState() => _VoiceMoodScreenState();
}

class _VoiceMoodScreenState extends State<VoiceMoodScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the mic to speak';
  String _moodResult = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult:
              (val) => setState(() {
                _text = val.recognizedWords;
              }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _analyzeMood(_text);
    }
  }

  Future<void> _analyzeMood(String userInput) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyDFyg2G719FomzpDEIR5-2JbMUxSWY94wg',
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
                    "Analyze the emotional tone of this sentence: $userInput",
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final textResponse = data['candidates'][0]['content']['parts'][0]['text'];
      setState(() {
        _moodResult = textResponse;
      });

      // Show motivational popup, breathing animation, and bubble popper game if mood is sad or depressed
      if (_moodResult.toLowerCase().contains("sad") ||
          _moodResult.toLowerCase().contains("depressed")) {
        await _showResult(_moodResult);
      }
    } else {
      setState(() {
        _moodResult = 'Error analyzing mood. (${response.statusCode})';
      });
    }
  }

  Future<void> _showResult(String result) async {
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Speech Emotion Analysis'),
            content: Text(result),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );

    // Motivational Quote
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Stay Strong'),
            content: Text('You’re doing better than you think. Keep going!'),
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
            title: Text('Take a Deep Breath'),
            content: Text('Inhale slowly... hold... and exhale.'),
            actions: [
              TextButton(
                child: Text('Done'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );

    // Launch the Game
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => BubblePopperScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Mood Analysis")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // <-- Add this line
          children: [
            Text(_text, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Center(
              // <-- Wrap IconButton with Center
              child: IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                onPressed: _listen,
                iconSize: 60,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _moodResult,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
