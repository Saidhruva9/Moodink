import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'secrets.dart'; // Ensure GEMINI_API_KEY is declared here

class MoodResponseService {
  static Future<void> showMotivationalPopup(BuildContext context) async {
    // Motivational Quote
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Stay Positive!'),
            content: const Text(
              'Remember, tough times never last but tough people do.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );

    // Breathing Animation
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Take a Deep Breath'),
            content: const Text('Breathe in... Breathe out...'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
    );

    // Launch the Bubble Popper Game
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const BubblePopperScreen()));
  }
}

// ------------------------- Bubble Popper Game --------------------------

class BubblePopperScreen extends StatefulWidget {
  const BubblePopperScreen({super.key});

  @override
  State<BubblePopperScreen> createState() => _BubblePopperScreenState();
}

class _BubblePopperScreenState extends State<BubblePopperScreen> {
  final Random _random = Random();
  final int _bubbleCount = 8;
  int _score = 0;
  late List<_Bubble> _bubbles;

  @override
  void initState() {
    super.initState();
    _resetBubbles();
  }

  void _resetBubbles() {
    _bubbles = List.generate(_bubbleCount, (_) => _randomBubble());
    _score = 0;
    setState(() {});
  }

  _Bubble _randomBubble() {
    return _Bubble(
      left: _random.nextDouble() * 250 + 20,
      top: _random.nextDouble() * 400 + 60,
      size: _random.nextDouble() * 40 + 40,
      color: Colors.primaries[_random.nextInt(Colors.primaries.length)]
          .withOpacity(0.7),
    );
  }

  void _popBubble(int index) {
    setState(() {
      _score++;
      _bubbles[index] = _randomBubble();
    });
    if (_score >= 10) {
      Future.delayed(const Duration(milliseconds: 300), () {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Great Job!'),
                content: const Text(
                  'You popped 10 bubbles!\nFeeling better? 😊',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetBubbles();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bubble Popper Game')),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF232526), Color(0xFF414345)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ..._bubbles.asMap().entries.map((entry) {
            final i = entry.key;
            final bubble = entry.value;
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: bubble.left,
              top: bubble.top,
              child: GestureDetector(
                onTap: () => _popBubble(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: bubble.size,
                  height: bubble.size,
                  decoration: BoxDecoration(
                    color: bubble.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: bubble.color.withOpacity(0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.bubble_chart,
                      color: Colors.white.withOpacity(0.7),
                      size: bubble.size * 0.6,
                    ),
                  ),
                ),
              ),
            );
          }),
          Positioned(
            top: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Score: $_score',
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                  foregroundColor: Colors.cyanAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble {
  final double left;
  final double top;
  final double size;
  final Color color;

  _Bubble({
    required this.left,
    required this.top,
    required this.size,
    required this.color,
  });
}

// ------------------------- Handwriting Analysis --------------------------

class HandwritingScreen extends StatefulWidget {
  const HandwritingScreen({super.key});

  @override
  State<HandwritingScreen> createState() => HandwritingScreenState();
}

class HandwritingScreenState extends State<HandwritingScreen> {
  File? _imageFile;
  String _result = '';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _analyzeWithGemini(_imageFile!);
    }
  }

  Future<void> _analyzeWithGemini(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

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
                    "Analyze this handwriting and describe the writer's emotional state and personality in simple language:",
              },
              {
                "inlineData": {"mimeType": "image/png", "data": base64Image},
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['candidates'][0]['content']['parts'][0]['text'];
      await _showResult(reply);
    } else {
      print('Gemini error: ${response.body}');
      await _showResult('Error analyzing handwriting. Try again.');
    }
  }

  Future<void> _showResult(String result) async {
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Gemini Analysis'),
            content: Text(result),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );

    if (result.toLowerCase().contains("sad") ||
        result.toLowerCase().contains("depressed")) {
      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Stay Positive!'),
              content: Text(
                'Remember, tough times never last but tough people do.',
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );

      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Take a Deep Breath'),
              content: Text('Breathe in... Breathe out...'),
              actions: [
                TextButton(
                  child: Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );

      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => BubblePopperScreen()));
    } else {
      setState(() => _result = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Handwriting Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Upload a handwriting sample for mood analysis.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _imageFile != null
                ? Image.file(_imageFile!, height: 200)
                : const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Handwriting Image'),
            ),
            const SizedBox(height: 20),
            Text(
              _result.isNotEmpty
                  ? _result
                  : (_imageFile != null ? 'Image selected!' : ''),
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
