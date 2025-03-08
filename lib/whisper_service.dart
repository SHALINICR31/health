import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WhisperService {
  final String apiKey = dotenv.env['OPENAI_API_KEY']!;
  // Replace with your OpenAI key

  Future<void> sendAudioToWhisper(String filePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
      );

      request.headers['Authorization'] = 'Bearer $apiKey';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ Whisper Response: $responseBody");
      } else {
        print("❌ Whisper API Error: ${response.statusCode}");
        print("Response: $responseBody");
      }
    } catch (e) {
      print("❌ Error sending audio: $e");
    }
  }
}

