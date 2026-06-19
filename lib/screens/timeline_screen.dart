import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_state.dart';
import '../widgets/glass_card.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(title: const Text('Memory Timeline'), backgroundColor: Colors.transparent),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final moods = state.allMoods;
          if (moods.isEmpty) {
            return const Center(child: Text("Your timeline is empty.", style: TextStyle(color: Colors.grey)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final log = moods[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: log.mood.color.withOpacity(0.1)),
                        child: Icon(Icons.circle, color: log.mood.color, size: 16),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.mood.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(DateFormat('EEEE, MMM d • h:mm a').format(log.dateTime), style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
              ).animate().fade(delay: (index * 50).ms).slideY(begin: 0.1);
            },
          );
        },
      ),
    );
  }
}
