import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceButton extends StatefulWidget {
  final Function(String?) onListeningEnd;

  const VoiceButton({super.key, required this.onListeningEnd});
  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> with SingleTickerProviderStateMixin {
  late SpeechToText _speech;
  late AudioPlayer _audioPlayer;
  bool _isRecording = false;
  late LocaleName locale;
  String listenedText = '';

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();

    _audioPlayer = AudioPlayer();
  }

  // Iniciar a gravação (e animação) ao pressionar o botão
  void _startRecording(LongPressStartDetails details) async {
    await _audioPlayer.play(AssetSource('sounds/beep.mp3'), volume: 1.0);
    if (!_isRecording) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          log('onStatus: $val');
          if (val == 'done') {
            setState(() {
              _isRecording = false;
              widget.onListeningEnd(listenedText);
              listenedText = '';
            });
          }
        },
        onError: (val) {
          log('onError: $val');
        },
      );
      if (available) {
        log("🎙️ Gravando...");
        if (!context.mounted) return;
        setState(() {
          _isRecording = true;
          _speech.listen(
              listenOptions: SpeechListenOptions(autoPunctuation: true),
              localeId: 'pt_BR',
              onResult: (result) {
                log(result.recognizedWords);
                listenedText = result.recognizedWords;
              });
        });
      }
    }
  }

  // Parar a gravação (e a animação)
  void _stopRecording(LongPressEndDetails details) {
    setState(() {
      _isRecording = false;
      _speech.stop();
    });
    log("🛑 Parou de gravar.");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _startRecording,
      onLongPressEnd: _stopRecording,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AvatarGlow(
              glowRadiusFactor: 0.3,
              duration: Duration(seconds: 2),
              repeat: true,
              animate: true,
              glowColor: _isRecording ? Colors.orange : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.mic,
                  size: 32,
                  color: _isRecording ? Colors.orange : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
