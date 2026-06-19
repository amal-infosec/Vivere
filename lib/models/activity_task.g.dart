// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityTaskAdapter extends TypeAdapter<ActivityTask> {
  @override
  final int typeId = 2;

  @override
  ActivityTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityTask(
      id: fields[0] as String?,
      title: fields[1] as String,
      isCompleted: fields[2] as bool,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityTask obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
