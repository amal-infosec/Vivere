import 'package:hive/hive.dart';
part 'daily_record.g.dart';

@HiveType(typeId: 3)
class DailyRecord extends HiveObject {
  @HiveField(0)
  final String dateStr; // Format: yyyy-MM-dd

  @HiveField(1)
  bool tookMedicine;

  DailyRecord({
    required this.dateStr,
    this.tookMedicine = false,
  });
}
