// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodLogAdapter extends TypeAdapter<MoodLog> {
  @override
  final int typeId = 1;

  @override
  MoodLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodLog(
      id: fields[0] as String?,
      mood: fields[1] as MoodStatus,
      dateTime: fields[2] as DateTime,
      note: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoodLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mood)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodStatusAdapter extends TypeAdapter<MoodStatus> {
  @override
  final int typeId = 0;

  @override
  MoodStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MoodStatus.crying;
      case 1:
        return MoodStatus.hurting;
      case 2:
        return MoodStatus.ok;
      case 3:
        return MoodStatus.happy;
      case 4:
        return MoodStatus.highConfidence;
      case 5:
        return MoodStatus.hyper;
      default:
        return MoodStatus.crying;
    }
  }

  @override
  void write(BinaryWriter writer, MoodStatus obj) {
    switch (obj) {
      case MoodStatus.crying:
        writer.writeByte(0);
        break;
      case MoodStatus.hurting:
        writer.writeByte(1);
        break;
      case MoodStatus.ok:
        writer.writeByte(2);
        break;
      case MoodStatus.happy:
        writer.writeByte(3);
        break;
      case MoodStatus.highConfidence:
        writer.writeByte(4);
        break;
      case MoodStatus.hyper:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
