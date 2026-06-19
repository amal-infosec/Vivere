import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_state.dart';
import '../models/activity_task.dart';
import '../widgets/glass_card.dart';

class DailyTrackScreen extends StatefulWidget {
  const DailyTrackScreen({super.key});

  @override
  State<DailyTrackScreen> createState() => _DailyTrackScreenState();
}

class _DailyTrackScreenState extends State<DailyTrackScreen> {
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    context.read<AppState>().addTask(_controller.text.trim(), DateTime.now());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        title: const Text('Plans vs Reality'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "What did you plan or do?",
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _addTask,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ).animate().scale(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Check off things you completed. Tap and hold to delete.",
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<AppState>(
                builder: (context, state, child) {
                  final tasks = state.getTasksForDate(DateTime.now());
                  if (tasks.isEmpty) {
                    return const Center(child: Text("Nothing added today. Start small!", style: TextStyle(color: Colors.grey)));
                  }
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        child: GlassCard(
                          padding: const EdgeInsets.all(4),
                          onTap: () => state.toggleTaskCompletion(task),
                          child: ListTile(
                            onLongPress: () => state.deleteTask(task),
                            leading: Container(
                              width: 24, height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: task.isCompleted ? Theme.of(context).colorScheme.primary : Colors.white54, width: 2),
                                color: task.isCompleted ? Theme.of(context).colorScheme.primary : Colors.transparent,
                              ),
                              child: task.isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted ? Colors.white38 : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ).animate().fade(delay: (index * 50).ms).slideX(begin: 0.05);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
