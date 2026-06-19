import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/mood_log.dart';
import '../models/activity_task.dart';
import '../models/daily_record.dart';

class AppState extends ChangeNotifier {
  late Box<MoodLog> _moodBox;
  late Box<ActivityTask> _activityBox;
  late Box<DailyRecord> _dailyBox;

  AppState() {
    _moodBox = Hive.box<MoodLog>('moods');
    _activityBox = Hive.box<ActivityTask>('activities');
    _dailyBox = Hive.box<DailyRecord>('daily_records');
  }

  List<MoodLog> get allMoods => _moodBox.values.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  
  List<ActivityTask> get allTasks => _activityBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  
  List<ActivityTask> getTasksForDate(DateTime date) {
    return _activityBox.values.where((task) {
      return task.date.year == date.year &&
             task.date.month == date.month &&
             task.date.day == date.day;
    }).toList();
  }

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  DailyRecord getRecordForDate(DateTime date) {
    String dateStr = _formatDate(date);
    if (!_dailyBox.containsKey(dateStr)) {
      final newRecord = DailyRecord(dateStr: dateStr);
      _dailyBox.put(dateStr, newRecord); 
      return newRecord;
    }
    return _dailyBox.get(dateStr)!;
  }

  Future<void> toggleMedicine(DateTime date) async {
    final record = getRecordForDate(date);
    record.tookMedicine = !record.tookMedicine;
    await record.save();
    notifyListeners();
  }

  Future<void> addMood(MoodStatus mood, {String? note}) async {
    final log = MoodLog(mood: mood, dateTime: DateTime.now(), note: note);
    await _moodBox.put(log.id, log);
    notifyListeners();
  }

  Future<void> addTask(String title, DateTime date) async {
    final task = ActivityTask(title: title, date: date);
    await _activityBox.put(task.id, task);
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(ActivityTask task) async {
    task.isCompleted = !task.isCompleted;
    await task.save();
    notifyListeners();
  }
  
  Future<void> deleteTask(ActivityTask task) async {
    await task.delete();
    notifyListeners();
  }

  List<Map<String, dynamic>> getTimelineLast24Hours() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));
    
    List<Map<String, dynamic>> timeline = [];
    
    // Add moods
    for (var mood in _moodBox.values) {
      if (mood.dateTime.isAfter(yesterday)) {
        timeline.add({
          'type': 'mood',
          'data': mood,
          'time': mood.dateTime,
        });
      }
    }
    
    // Add tasks
    for (var task in _activityBox.values) {
      if (task.date.isAfter(yesterday)) {
        timeline.add({
          'type': 'task',
          'data': task,
          'time': task.date,
        });
      }
    }
    
    timeline.sort((a, b) => (b['time'] as DateTime).compareTo(a['time'] as DateTime));
    return timeline;
  }

  MoodStatus? getDominantMoodForDate(DateTime date) {
    final logs = _moodBox.values.where((log) => _formatDate(log.dateTime) == _formatDate(date)).toList();
    if (logs.isEmpty) return null;
    logs.sort((a,b) => b.dateTime.compareTo(a.dateTime));
    return logs.first.mood;
  }
}

extension MoodStatusExtension on MoodStatus {
  String get label {
    switch (this) {
      case MoodStatus.crying: return "Crying";
      case MoodStatus.hurting: return "Hurting";
      case MoodStatus.ok: return "Ok";
      case MoodStatus.happy: return "Happy";
      case MoodStatus.highConfidence: return "High Confidence";
      case MoodStatus.hyper: return "Hyper";
    }
  }

  Color get color {
    switch (this) {
      case MoodStatus.crying: return const Color(0xFF3B82F6); 
      case MoodStatus.hurting: return const Color(0xFFEF4444); 
      case MoodStatus.ok: return const Color(0xFF10B981); 
      case MoodStatus.happy: return const Color(0xFFF59E0B); 
      case MoodStatus.highConfidence: return const Color(0xFF8B5CF6); 
      case MoodStatus.hyper: return const Color(0xFFF43F5E); 
    }
  }
}
