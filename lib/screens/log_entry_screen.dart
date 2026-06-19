import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/mood_log.dart';
import 'audio_journal_widget.dart';

class LogEntryScreen extends StatefulWidget {
  const LogEntryScreen({super.key});

  @override
  State<LogEntryScreen> createState() => _LogEntryScreenState();
}

class _LogEntryScreenState extends State<LogEntryScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addPresetTask(String title) {
    if (title.isEmpty) return;
    final formattedTitle = title[0].toUpperCase() + title.substring(1);
    context.read<AppState>().addTask(formattedTitle, DateTime.now());
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged: $formattedTitle', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.white.withOpacity(0.1)));
    }
  }

  void _addCustomNote() {
    final text = _noteController.text.trim();
    if (text.isNotEmpty) {
      final formattedText = text[0].toUpperCase() + text.substring(1);
      context.read<AppState>().addTask(formattedText, DateTime.now());
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note added', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.white.withOpacity(0.1)));
      }
    }
  }

  Widget _buildPresetTile(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF18181B), // Slightly lighter black than background
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        top: 24, left: 24, right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 24),
            const Text("How are you feeling?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const MiniMoodSelector(),
            const SizedBox(height: 32),
            
            const AudioJournalWidget(),
            const SizedBox(height: 32),

            const Text("Add Custom Note / Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: "Type note here...",
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: (_) => _addCustomNote(),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: _addCustomNote,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const Text("Quick Presets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildPresetTile("Food", Icons.restaurant, () => _addPresetTask("Food")),
                _buildPresetTile("Medicine", Icons.medical_services, () => _addPresetTask("Medicine")),
                _buildPresetTile("Sleep", Icons.nightlight_round, () => _addPresetTask("Sleep")),
                _buildPresetTile("Walk", Icons.directions_walk, () => _addPresetTask("Walk")),
                _buildPresetTile("Exercise", Icons.fitness_center, () => _addPresetTask("Exercise")),
                _buildPresetTile("Socialize", Icons.people, () => _addPresetTask("Socialize")),
                _buildPresetTile("Hydrate", Icons.water_drop, () => _addPresetTask("Hydrate")),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class MiniMoodSelector extends StatelessWidget {
  const MiniMoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: MoodStatus.values.map((mood) {
        return GestureDetector(
          onTap: () {
            context.read<AppState>().addMood(mood);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged: ${mood.label}', style: TextStyle(color: Colors.white)), backgroundColor: Colors.white.withOpacity(0.1)));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: mood.color.withOpacity(0.4), width: 1.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: mood.color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: mood.color.withOpacity(0.8), blurRadius: 8, spreadRadius: 2)]),
                ),
                const SizedBox(width: 10),
                Text(mood.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
