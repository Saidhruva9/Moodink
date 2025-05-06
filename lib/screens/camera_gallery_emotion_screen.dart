import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_image_emotion_service.dart';

class CameraGalleryEmotionScreen extends StatefulWidget {
  @override
  _CameraGalleryEmotionScreenState createState() =>
      _CameraGalleryEmotionScreenState();
}

class _CameraGalleryEmotionScreenState
    extends State<CameraGalleryEmotionScreen> {
  final picker = ImagePicker();
  final geminiService = GeminiImageEmotionService();

  File? _image;
  String _emotion = '';

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _emotion = '';
      });
      await _analyzeImage(File(pickedFile.path));
    }
  }

  Future<void> _analyzeImage(File image) async {
    final emotion = await geminiService.analyzeImageEmotion(image);
    setState(() {
      _emotion = emotion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detect Emotion from Image')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 300),
            SizedBox(height: 20),
            if (_emotion.isNotEmpty)
              Text(
                'Detected Emotion: $_emotion',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera),
                  label: Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo),
                  label: Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
