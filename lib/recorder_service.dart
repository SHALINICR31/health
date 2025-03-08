import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class RecorderService {
  FlutterSoundRecorder? _recorder;
  bool isRecording = false;
  String? filePath;

  RecorderService() {
    _recorder = FlutterSoundRecorder();
  }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> startRecording() async {
    await requestMicrophonePermission();

    Directory tempDir = await getApplicationDocumentsDirectory();
    filePath = '${tempDir.path}/recorded_audio.wav';

    await _recorder!.openRecorder();
    await _recorder!.startRecorder(toFile: filePath);
    isRecording = true;
    print("🎤 Recording started...");
  }

  Future<void> stopRecording() async {
    if (_recorder != null && isRecording) {
      await _recorder!.stopRecorder();
      await _recorder!.closeRecorder();
      isRecording = false;
      print("⏹️ Recording stopped. File saved at: $filePath");
    }
  }
}
