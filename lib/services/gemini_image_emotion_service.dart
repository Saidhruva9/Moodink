import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiImageEmotionService {
  final String apiKey =
      'AIzaSyDFyg2G719FomzpDEIR5-2JbMUxSWY94wg'; // Replace with your key

  Future<String> analyzeImageEmotion(File imageFile) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    final prompt = TextPart(
      'Analyze the facial expression in the image and predict the emotion (happy, sad, angry, surprised, calm, fearful, disgusted, neutral). Respond ONLY with the emotion name.',
    );

    final imageBytes = await imageFile.readAsBytes();
    final imagePart = DataPart('image/jpeg', imageBytes);

    final response = await model.generateContent([
      Content.multi([prompt, imagePart]),
    ]);

    return response.text ?? 'Could not detect emotion.';
  }
}
