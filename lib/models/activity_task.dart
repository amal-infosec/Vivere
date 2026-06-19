import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'activity_task.g.dart';

@HiveType(typeId: 2)
class ActivityTask extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  final DateTime date;

  ActivityTask({
    String? id,
    required this.title,
    this.isCompleted = false,
    required this.date,
  }) : id = id ?? const Uuid().v4();
}
