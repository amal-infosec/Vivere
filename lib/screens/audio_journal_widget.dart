import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/glass_card.dart';

class AudioJournalWidget extends StatefulWidget {
  const AudioJournalWidget({super.key});

  @override
  State<AudioJournalWidget> createState() => _AudioJournalWidgetState();
}

class _AudioJournalWidgetState extends State<AudioJournalWidget> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  void _toggleRecord() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.white.withOpacity(0.1),
              content: const Text('Audio saved securely offline.', style: TextStyle(color: Colors.white))
          ),
        );
      }
    } else {
      if (await Permission.microphone.request().isGranted) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
        });
      } else {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red.withOpacity(0.8),
                content: const Text('Microphone permission required.', style: TextStyle(color: Colors.white))
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Brain Dump", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  _isRecording ? "Recording... tap to stop" : "Too tired to type? Tap to record.", 
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _toggleRecord,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isRecording ? Colors.redAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: _isRecording ? Colors.redAccent : Colors.transparent),
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: _isRecording ? Colors.redAccent : Colors.white70,
              ),
            ).animate(target: _isRecording ? 1 : 0)
              .scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1))
              .tint(color: Colors.redAccent, end: 0.3),
          )
        ],
      ),
    );
  }
}
