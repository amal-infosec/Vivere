import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_state.dart';
import '../widgets/glass_card.dart';
import '../models/activity_task.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF09090B),
        appBar: AppBar(
          title: const Text('Stats & History', style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorColor: Color(0xFF6366F1),
            labelColor: Color(0xFF6366F1),
            unselectedLabelColor: Colors.white54,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: "Mood Logs"),
              Tab(text: "Activity Log"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MoodLogsTab(),
            _ActivityLogTab(),
          ],
        ),
      ),
    );
  }
}

class _MoodLogsTab extends StatelessWidget {
  const _MoodLogsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        final daysList = List.generate(31, (index) => thirtyDaysAgo.add(Duration(days: index)));

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("Monthly Heatmap", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: daysList.map((day) {
                  final mood = state.getDominantMoodForDate(day);
                  final medRecord = state.getRecordForDate(day);
                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: mood?.color.withOpacity(0.8) ?? Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: medRecord.tookMedicine ? Colors.white70 : Colors.transparent, width: 2),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fade().slideY(begin: 0.1),
            
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(border: Border.all(color: Colors.white70, width: 2), borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 6),
                const Text("Took Meds", style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 40),
            const Text("Extended History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            if (state.allMoods.isEmpty)
               const Center(child: Text("Your mood history is empty.", style: TextStyle(color: Colors.grey)))
            else
               ...state.allMoods.map((log) => Padding(
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
                ).animate().fade().slideX(begin: 0.05)
               ).toList(),
          ],
        );
      },
    );
  }
}

class _ActivityLogTab extends StatelessWidget {
  const _ActivityLogTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final tasks = state.allTasks;
        
        if (tasks.isEmpty) {
          return const Center(child: Text("No activities logged yet.", style: TextStyle(color: Colors.white54)));
        }

        // Group tasks by date string e.g., "Monday, May 19"
        Map<String, List<ActivityTask>> groupedMap = {};
        for (var task in tasks) {
          String dateKey = DateFormat('EEEE, MMMM d').format(task.date);
          if (!groupedMap.containsKey(dateKey)) {
            groupedMap[dateKey] = [];
          }
          groupedMap[dateKey]!.add(task);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: groupedMap.keys.length,
          itemBuilder: (context, index) {
            String dateKey = groupedMap.keys.elementAt(index);
            List<ActivityTask> dayTasks = groupedMap[dateKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(dateKey, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
                ),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dayTasks.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.white.withOpacity(0.05)),
                    itemBuilder: (context, taskIdx) {
                      final task = dayTasks[taskIdx];
                      return ListTile(
                        leading: Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          ),
                          child: const Icon(Icons.check, size: 14, color: Colors.white),
                        ),
                        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(DateFormat('h:mm a').format(task.date), style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      );
                    },
                  ),
                ).animate().fade().slideY(begin: 0.05),
              ],
            );
          },
        );
      },
    );
  }
}
