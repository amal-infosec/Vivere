import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_state.dart';
import '../models/mood_log.dart';
import '../models/activity_task.dart';
import '../widgets/glass_card.dart';
import 'stats_screen.dart';
import 'log_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Stack(
        children: [
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                boxShadow: [BoxShadow(blurRadius: 100, color: Theme.of(context).colorScheme.primary.withOpacity(0.2))],
              ),
            ).animate(onPlay: (ctrl) => ctrl.repeat(reverse: true)).scale(duration: 4.seconds, begin: const Offset(1,1), end: const Offset(1.1,1.1)),
          ),
          
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text('Vivere', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.bar_chart, color: Colors.white70),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen())),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          DateFormat('EEEE, MMMM d').format(DateTime.now()),
                          style: const TextStyle(fontSize: 16, color: Colors.white54, fontWeight: FontWeight.w500),
                        ).animate().fade().slideY(begin: 0.1),
                        const SizedBox(height: 8),
                        const Text(
                          "Today's Overview",
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, letterSpacing: -0.5),
                        ).animate().fade(delay: 100.ms).slideY(begin: 0.1),
                        const SizedBox(height: 32),
                        
                        // Medicine Toggle
                        const MedicineToggleCard().animate().fade(delay: 200.ms).slideY(begin: 0.1),
                        const SizedBox(height: 16),
                        
                        // Dominant Mood Card
                        const DominantMoodCard().animate().fade(delay: 300.ms).slideY(begin: 0.1),
                        const SizedBox(height: 32),

                        const Text("Last 24 Hours Activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white54)),
                        const SizedBox(height: 12),
                        const Timeline24Hours().animate().fade(delay: 400.ms),
                        
                        const SizedBox(height: 100), // padding for FAB
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const LogEntryScreen(),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Log", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ).animate().scale(delay: 600.ms),
    );
  }
}

class MedicineToggleCard extends StatelessWidget {
  const MedicineToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final record = state.getRecordForDate(DateTime.now());
        final isTaken = record.tookMedicine;

        return GestureDetector(
          onTap: () => state.toggleMedicine(DateTime.now()),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: isTaken ? Colors.green.withOpacity(0.15) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isTaken ? Colors.green : Colors.white.withOpacity(0.1), 
                width: 2,
              ),
              boxShadow: isTaken ? [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 20)] : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isTaken ? Icons.check_circle : Icons.medication, 
                  color: isTaken ? Colors.green : Colors.white70,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  isTaken ? "Medicine Logged!" : "Tap to Log Medicine", 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18,
                    color: isTaken ? Colors.green : Colors.white,
                  )
                ),
              ],
            ),
          ).animate(target: isTaken ? 1 : 0)
           .scale(begin: const Offset(1,1), end: const Offset(1.02, 1.02), curve: Curves.easeOut)
           .shimmer(duration: 1.seconds, color: Colors.green.withOpacity(0.5)),
        );
      },
    );
  }
}

class DominantMoodCard extends StatelessWidget {
  const DominantMoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final mood = state.getDominantMoodForDate(DateTime.now());
        
        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Latest Mood", style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (mood == null)
                const Text("No mood logged today.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300))
              else
                Row(
                  children: [
                    Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(color: mood.color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: mood.color.withOpacity(0.5), blurRadius: 6)]),
                    ),
                    const SizedBox(width: 12),
                    Text(mood.label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class Timeline24Hours extends StatelessWidget {
  const Timeline24Hours({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final timeline = state.getTimelineLast24Hours();
        if (timeline.isEmpty) {
          return const GlassCard(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Nothing logged in the last 24 hours.", style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic)),
            ),
          );
        }

        return GlassCard(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeline.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.white.withOpacity(0.05)),
            itemBuilder: (context, index) {
              final item = timeline[index];
              if (item['type'] == 'mood') {
                final MoodLog log = item['data'];
                return ListTile(
                  leading: Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: log.mood.color.withOpacity(0.2)),
                    child: Icon(Icons.circle, color: log.mood.color, size: 14),
                  ),
                  title: Text("Felt ${log.mood.label}", style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(DateFormat('h:mm a').format(log.dateTime), style: const TextStyle(color: Colors.white38, fontSize: 12)),
                );
              } else {
                final ActivityTask task = item['data'];
                return ListTile(
                  onTap: () => state.toggleTaskCompletion(task),
                  onLongPress: () => state.deleteTask(task),
                  leading: Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: task.isCompleted ? Theme.of(context).colorScheme.primary : Colors.white38, width: 2),
                      color: task.isCompleted ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    ),
                    child: task.isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.white38 : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(DateFormat('h:mm a').format(task.date), style: const TextStyle(color: Colors.white38, fontSize: 12)),
                );
              }
            },
          ),
        );
      },
    );
  }
}
