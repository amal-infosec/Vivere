import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'mood_log.g.dart';

@HiveType(typeId: 0)
enum MoodStatus {
  @HiveField(0)
  crying,
  @HiveField(1)
  hurting,
  @HiveField(2)
  ok,
  @HiveField(3)
  happy,
  @HiveField(4)
  highConfidence,
  @HiveField(5)
  hyper,
}

@HiveType(typeId: 1)
class MoodLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final MoodStatus mood;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String? note;

  MoodLog({
    String? id,
    required this.mood,
    required this.dateTime,
    this.note,
  }) : id = id ?? const Uuid().v4();
}
